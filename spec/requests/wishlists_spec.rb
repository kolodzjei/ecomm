# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Wishlists", type: :request) do
  let(:user) { create(:user) }
  let(:product) { create(:product) }

  describe "GET /wishlist" do
    it "redirects to login page if not logged in" do
      get wishlists_path
      expect(response).to(redirect_to(login_path))
    end

    it "returns http success if logged in" do
      login_as user
      get wishlists_path
      expect(response).to(have_http_status(:success))
    end
  end

  describe "POST /wishlist/add/:product_id" do
    it "redirects to login page if not logged in" do
      post wishlist_add_path(product)
      expect(response).to(redirect_to(login_path))
    end

    it "redirects to wishlist and adds product if logged in" do
      login_as user
      expect do
        post(wishlist_add_path(product))
      end.to(change { current_user.wishlist.products.count }.by(1))
      expect(response).to(redirect_to(wishlists_path))
    end
  end

  describe "DELETE /wishlist/remove/:product_id" do
    it "redirects to login page if not logged in" do
      delete wishlist_remove_path(product)
      expect(response).to(redirect_to(login_path))
    end

    it "redirects to wishlist and removes product if logged in" do
      login_as user
      current_user.wishlist.products << product
      expect do
        delete(wishlist_remove_path(product))
      end.to(change { current_user.wishlist.products.count }.by(-1))
      expect(response).to(redirect_to(wishlists_path))
    end
  end
end
