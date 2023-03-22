# frozen_string_literal: true

class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user, only: [:show]

  def show
    @cart = current_user.cart
  end

  private

  def check_user
    redirect_to cart_path(current_user.cart) unless current_user.cart.id == params[:id].to_i
  end
end
