# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Items", type: :request) do
  let(:product) { create(:product) }
  describe "POST /items" do
    let(:user) { create(:user) }
    let(:product) { create(:product) }
    it "redirects to login if user is not logged in" do
      expect do
        post(items_path, params: { product_id: product.id })
      end.to(change(Item, :count).by(0))
      expect(response).to(redirect_to(login_path))
    end

    it "redirects to root if product does not exist" do
      login_as user
      expect do
        post(items_path, params: { product_id: -1 })
      end.to(change(Item, :count).by(0))
      expect(response).to(redirect_to(root_path))
    end

    it "creates an item if product exist and user is logged in" do
      login_as user
      expect do
        post(items_path, params: { product_id: product.id })
      end.to(change(Item, :count).by(1))
      expect(response).to(redirect_to(carts_path))
    end

    it "updates items quantity if user already has an item with this product" do
      login_as user
      post items_path, params: { product_id: product.id }
      expect do
        post(items_path, params: { product_id: product.id })
      end.to(change(Item, :count).by(0))
      expect(response).to(redirect_to(carts_path))
      expect(Item.first.quantity).to(eq(2))
    end
  end

  describe "DELETE /items/:id" do
    describe "when user is not logged in" do
      before :each do
        @item = create(:item, :with_user_and_product)
        @user = @item.cart.user
      end

      it "redirects to login" do
        delete item_path(@item)
        expect(response).to(redirect_to(login_path))
      end

      it "does not delete item" do
        expect do
          delete(item_path(1))
        end.to(change(Item, :count).by(0))
      end
    end

    describe "when user is logged in" do
      before :each do
        @item = create(:item, :with_user_and_product)
        @user = @item.cart.user
        login_as @user
      end

      it "redirects to root if item does not exist" do
        delete item_path(-1)
        expect(response).to(redirect_to(root_path))
      end

      it "redirects to root if item does not belong to user" do
        user = create(:admin)
        item = Item.create(product_id: product.id, cart_id: user.cart.id, quantity: 1)
        expect do
          delete(item_path(item))
        end.to(change(Item, :count).by(0))
        expect(response).to(redirect_to(root_path))
      end

      it "deletes item if it exists and belongs to user" do
        expect do
          delete(item_path(@item))
        end.to(change(Item, :count).by(-1))
        expect(response).to(redirect_to(carts_path))
      end
    end
  end

  describe "POST /items/:id/add" do
    describe "when user is not logged in" do
      before :each do
        @item = create(:item, :with_user_and_product)
        @user = @item.cart.user
      end

      it "redirects to login" do
        post add_item_path(@item)
        expect(response).to(redirect_to(login_path))
      end

      it "does not update item" do
        expect do
          post(add_item_path(@item))
        end.to(change { @item.reload.quantity }.by(0))
      end
    end

    describe "when user is logged in" do
      before :each do
        @item = create(:item, :with_user_and_product)
        @user = @item.cart.user
        login_as @user
      end

      it "redirects to root if item does not exist" do
        post add_item_path(-1)
        expect(response).to(redirect_to(root_path))
      end

      it "redirects to root if item does not belong to user" do
        user = create(:admin)
        i = Item.create(product_id: product.id, cart_id: user.cart.id, quantity: 1)
        expect do
          post(add_item_path(i))
        end.to(change { i.reload.quantity }.by(0))
        expect(response).to(redirect_to(root_path))
      end

      it "updates items quantity if it exists and belongs to user" do
        expect do
          post(add_item_path(@item))
        end.to(change { @item.reload.quantity }.by(1))
        expect(response).to(redirect_to(carts_path))
      end
    end
  end

  describe "DELETE /items/:id/remove" do
    describe "when user is not logged in" do
      before :each do
        @item = create(:item, :with_user_and_product)
        @user = @item.cart.user
      end

      it "redirects to login" do
        delete remove_item_path(@item)
        expect(response).to(redirect_to(login_path))
      end

      it "does not update item" do
        expect do
          delete(remove_item_path(@item))
        end.to(change { @item.reload.quantity }.by(0))
      end
    end

    describe "when user is logged in" do
      before :each do
        @item = create(:item, :with_user_and_product)
        @user = @item.cart.user
        login_as @user
      end

      it "redirects to root if item does not exist" do
        delete remove_item_path(-1)
        expect(response).to(redirect_to(root_path))
      end

      it "redirects to root if item does not belong to user" do
        user = create(:admin)
        i = Item.create(product_id: 1, cart_id: user.cart.id, quantity: 1)
        expect do
          delete(remove_item_path(i))
        end.to(change { i.reload.quantity }.by(0))
        expect(response).to(redirect_to(root_path))
      end

      it "updates quantity if its >1 and item belongs to user" do
        @item.update_attribute(:quantity, 5)
        expect do
          delete(remove_item_path(@item))
        end.to(change { @item.reload.quantity }.by(-1))
        expect(response).to(redirect_to(carts_path))
      end

      it "does not update quantity if its 1 and item belongs to user" do
        expect do
          delete(remove_item_path(@item))
        end.to(change { @item.reload.quantity }.by(0))
        expect(response).to(redirect_to(carts_path))
      end
    end
  end

  describe "POST /cart/add/:product_id" do
    let(:user) { create(:user) }

    it "redirects to login if user is not logged in" do
      post cart_add_path(product.id)
      expect(response).to(redirect_to(login_path))
    end

    it "redirects to root if product does not exist" do
      login_as user
      post cart_add_path(-1)
      expect(response).to(redirect_to(root_path))
    end

    it "adds item to cart if product exists and user is logged in" do
      login_as user
      create(:product)
      expect do
        post(cart_add_path(1))
      end.to(change(Item, :count).by(1))
      expect(response).to(redirect_to(carts_path))
    end
  end
end
