# frozen_string_literal: true

class ItemsController < ApplicationController
  before_action :authenticate_user!
  # before_action :check_user, only: %i[create destroy add remove]

  def create
    product = Product.find_by(id: params[:item][:product_id])
    cart = current_user.cart if current_user.cart.id == params[:item][:cart_id].to_i

    if product && cart

      if cart.items.find_by(product_id: product.id)
        item = cart.items.find_by(product_id: product.id)
        item.update_attribute(:quantity, item.quantity + 1)
        item.save
      else
        cart.items.create(product_id: product.id, quantity: 1, cart_id: cart.id)
      end

      flash[:notice] = 'Item added to cart'
      redirect_to cart_path(cart)
    else
      flash[:alert] = 'Something went wrong'
      redirect_to root_path
    end
  end

  def destroy
    item = Item.find_by(id: params[:id])
    if item && current_user.cart.id == item.cart_id
      item.destroy
      redirect_to cart_path(item.cart)
    else
      flash[:alert] = 'Something went wrong'
      redirect_to root_path
    end
  end

  def add
    item = Item.find_by(id: params[:id])
    if item && current_user.cart.id == item.cart_id
      item.update_attribute(:quantity, item.quantity + 1)
      redirect_to cart_path(item.cart)
    else
      flash[:alert] = 'Something went wrong'
      redirect_to root_path
    end
  end

  def remove
    item = Item.find_by(id: params[:id])
    if item && current_user.cart.id == item.cart_id
      item.update_attribute(:quantity, item.quantity - 1) if item.quantity > 1
      redirect_to cart_path(item.cart)
    else
      flash[:alert] = 'Something went wrong'
      redirect_to root_path
    end
  end

  private

  def item_params
    params.require(:item).permit(:product_id, :cart_id)
  end

  # def check_user
  #   redirect_to root_path unless current_user.cart.id == params[:item][:cart_id].to_i
  # end
end
