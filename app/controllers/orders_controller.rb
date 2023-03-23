# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!, only: %i[ship index]
  before_action :check_cart, only: %i[new create]

  def new
    @order = Order.new
    @cart = current_user.cart
  end

  def create
    @order = Order.new(order_params)
    @order.user = current_user

    @order.user.cart.items.each do |item|
      @order.items << item
      item.cart_id = nil
      item.save
    end

    @order.save
    flash[:success] = 'Order placed successfully'
    redirect_to @order
  end

  def show
    @order = Order.find_by(id: params[:id])
    redirect_to root_path unless @order && (@order.user == current_user || current_user.admin?)
  end

  def index
    @orders = Order.all
  end

  def cancel
    @order = Order.find_by(id: params[:id])
    if @order && @order.user == current_user && @order.status == 'pending'
      @order.cancel
      @order.save
      flash[:success] = 'Order cancelled successfully'
      redirect_to @order
    elsif @order && current_user.admin?
      @order.cancel
      @order.save
      flash[:success] = 'Order cancelled successfully'
      redirect_to @order
    else
      flash[:alert] = 'Something went wrong'
      redirect_to root_path
    end
  end

  def pay
    @order = Order.find_by(id: params[:id])
    if @order && @order.user == current_user
      if @order.status != 'pending'
        flash[:alert] = 'You cant do that right now'
        redirect_to @order
      end
    else
      flash[:alert] = 'Something went wrong'
      redirect_to root_path
    end
  end

  def ship
    @order = Order.find_by(id: params[:id])
    if @order
      @order.ship
      @order.save
      flash[:success] = 'Order updated successfully'
      redirect_to @order
    else
      flash[:alert] = 'Something went wrong'
      redirect_to root_path
    end
  end

  def receive
    @order = Order.find_by(id: params[:id])
    if @order && (@order.user == current_user || current_user.admin?)
      @order.receive
      @order.save
      flash[:success] = 'Order updated successfully'
      redirect_to @order
    else
      flash[:alert] = 'Something went wrong'
      redirect_to root_path
    end
  end

  def paid
    @order = Order.find_by(id: params[:id])
    if @order && @order.user == current_user
      if @order.status == 'pending'
        @order.pay
        @order.save
        flash[:success] = 'Payment successful'
      else
        flash[:alert] = "You can't do that right now"
      end
      redirect_to @order
    else
      flash[:alert] = 'Something went wrong'
      redirect_to root_path
    end
  end

  private

  def order_params
    params.require(:order).permit(:shipping_name, :shipping_address_line_1, :shipping_address_line_2, :shipping_city,
                                  :shipping_zipcode, :shipping_country)
  end

  def check_cart
    return unless current_user.cart.items.empty?

    flash[:alert] = 'Your cart is empty'
    redirect_to root_path
  end
end
