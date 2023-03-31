# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Reviews", type: :request) do
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }
  let(:product) { create(:product) }

  describe "POST /reviews" do
    it "redirects to login page if user is not logged in" do
      post reviews_path, params: { review: { rating: 5, content: "Great product", product_id: product.id } }
      expect(response).to(redirect_to(login_path))
    end

    it "redirects to product page and does not create another review if user has already reviewed the product" do
      login_as user
      create(:review, :with_specific_user_and_product, user_id: user.id, product_id: product.id)
      expect do
        post(reviews_path, params: { review: { rating: 5, content: "Great product", product_id: product.id } })
      end.to(change { Review.count }.by(0))
      expect(response).to(redirect_to(product_path(product.id)))
      expect(flash[:alert]).to(eq("You have already reviewed this product"))
    end

    it "redirects to product page and does not create it if review is not valid" do
      login_as user
      expect do
        post(reviews_path, params: { review: { rating: -1, content: "", product_id: product.id } })
      end.to(change { Review.count }.by(0))
      expect(response).to(redirect_to(product_path(product.id)))
      expect(flash[:alert]).to(eq("Review not created"))
    end

    it "creates product and redirects to it if review is valid" do
      login_as user
      expect do
        post(reviews_path, params: { review: { rating: 5, content: "Great product", product_id: product.id } })
      end.to(change { Review.count }.by(1))
      expect(response).to(redirect_to(product_path(product.id)))
      expect(flash[:notice]).to(eq("Review created successfully"))
    end
  end

  describe "DELETE /reviews/:id" do
    let(:review) { create(:review, :with_specific_user_and_product, user_id: user.id, product_id: product.id) }
    it "redirects to login page if user is not logged in" do
      delete review_path(-1)
      expect(response).to(redirect_to(login_path))
    end

    it "redirects to product page and does not delete review if user is not the owner of the review" do
      review
      login_as create(:user2)
      expect do
        delete(review_path(review.id))
      end.to(change { Review.count }.by(0))
      expect(response).to(redirect_to(product_path(review.product)))
      expect(flash[:alert]).to(eq("Access denied."))
    end

    it "redirects to product page and deletes review if user is owner" do
      review
      login_as user
      expect do
        delete(review_path(review.id))
      end.to(change { Review.count }.by(-1))
      expect(response).to(redirect_to(product_path(review.product)))
      expect(flash[:notice]).to(eq("Review deleted successfully"))
    end

    it "redirects to product page and deletes review if user is admin" do
      review
      login_as admin
      expect do
        delete(review_path(review.id))
      end.to(change { Review.count }.by(-1))
      expect(response).to(redirect_to(product_path(review.product)))
      expect(flash[:notice]).to(eq("Review deleted successfully"))
    end
  end
end
