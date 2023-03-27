# frozen_string_literal: true

class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    @review = Review.new(review_params)
    @review.user = current_user

    if current_user.reviews.find_by(product_id: @review.product_id)
      flash[:alert] = 'You have already reviewed this product'
    elsif @review.save
      flash[:notice] = 'Review created successfully'
    else
      flash[:alert] = 'Review not created'
    end
    redirect_to product_path(@review.product)
  end

  def destroy
    @review = Review.find_by(id: params[:id])

    if @review.user == current_user || current_user.admin?
      flash[:notice] = 'Review deleted successfully'
      @review.destroy
    else
      flash[:alert] = 'Access denied.'
    end
    redirect_to product_path(@review.product)
  end

  private

  def review_params
    params.require(:review).permit(:rating, :content, :product_id)
  end
end
