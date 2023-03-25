# frozen_string_literal: true

class WishlistsController < ApplicationController
  before_action :authenticate_user!

  def index
    @wishlist = current_user.wishlist
    @products = @wishlist.products
  end

  def create
    @product = Product.find_by(id: params[:product_id])
    current_user.wishlist.products << @product unless current_user.wishlist.products.include?(@product)
    redirect_to wishlists_path
  end

  def destroy
    @product = Product.find_by(id: params[:product_id])
    current_user.wishlist.products.delete(@product)
    redirect_to wishlists_path
  end
end
