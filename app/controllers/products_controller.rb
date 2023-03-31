# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :authenticate_admin!, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:show]

  def index
    @pagy, @products = pagy(Product.all, items: 12)
  end

  def show
    @product = Product.find_by(id: params[:id])
    return unless @product.nil?

    flash[:alert] = "Product not found"
    redirect_to(root_url)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.image.attach(params[:product][:image])

    unless params[:product][:category_ids].nil?
      params[:product][:category_ids][1..].each do |category_id|
        @product.categories << Category.find_by(id: category_id)
      end
    end

    if @product.save
      flash[:success] = "Product created"
      redirect_to(@product)
    else
      flash.now[:alert] = "Product not created"
      render(:new, status: :unprocessable_entity)
    end
  end

  def edit
    @product = Product.find_by(id: params[:id])
  end

  def update
    @product = Product.find_by(id: params[:id])
    @product.update(product_params)

    @product.categories.clear
    unless params[:product][:category_ids].nil?
      params[:product][:category_ids][1..].each do |category_id|
        @product.categories << Category.find_by(id: category_id)
      end
    end

    if @product.save
      flash[:success] = "Product updated"
      redirect_to(@product)
    else
      flash.now[:alert] = "Product not updated"
      render(:edit, status: :unprocessable_entity)
    end
  end

  def destroy
    @product = Product.find_by(id: params[:id])
    @product.destroy
    flash[:success] = "Product deleted"
    redirect_back_or_to(root_url)
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :image)
  end
end
