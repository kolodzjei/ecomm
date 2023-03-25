# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Items', type: :request do
  describe 'POST /items' do
    it 'redirects to login if user is not logged in' do
      expect do
        post items_path, params: { item: { product_id: 1, cart_id: 1 } }
      end.to change(Item, :count).by(0)
      expect(response).to redirect_to(login_path)
    end

    it 'redirects to root if product does not exist' do
      log_in_user
      expect do
        post items_path, params: { item: { product_id: 1, cart_id: 1 } }
      end.to change(Item, :count).by(0)
      expect(response).to redirect_to(root_path)
    end

    it 'redirects to root if cart does not exist' do
      log_in_user
      Product.create(name: 'test', price: 1, description: 'test')
      expect do
        post items_path, params: { item: { product_id: 1, cart_id: 2 } }
      end.to change(Item, :count).by(0)
      expect(response).to redirect_to root_path
    end

    it 'redirects to root if cart does not belong to user' do
      log_in_user
      Product.create(name: 'test', price: 1, description: 'test')
      create(:admin)
      expect do
        post items_path, params: { item: { product_id: 1, cart_id: 2 } }
      end.to change(Item, :count).by(0)
      expect(response).to redirect_to root_path
    end

    it 'creates an item if product and cart exist and belong to user' do
      log_in_user
      Product.create(name: 'test', price: 1, description: 'test')
      expect do
        post items_path, params: { product_id: 1 }
      end.to change(Item, :count).by(1)
      expect(response).to redirect_to carts_path
    end

    it 'updates an item if product and cart exist and belong to user' do
      log_in_user
      Product.create(name: 'test', price: 1, description: 'test')
      post items_path, params: { product_id: 1 }
      expect do
        post items_path, params: { product_id: 1 }
      end.to change(Item, :count).by(0)
      expect(response).to redirect_to carts_path
      expect(Item.first.quantity).to eq(2)
    end

    it 'redirects to root if product and cart exist but do not belong to user' do
      log_in_user
      create(:admin)
      Product.create(name: 'test', price: 1, description: 'test')
      expect do
        post items_path, params: { item: { product_id: 1, cart_id: 2 } }
      end.to change(Item, :count).by(0)
      expect(response).to redirect_to root_path
    end
  end

  describe 'DELETE /items/:id' do
    describe 'when user is not logged in' do
      before :each do
        Product.create(name: 'test', price: 1, description: 'test')
        create(:user)
        @item = Item.create(product_id: 1, cart_id: 1, quantity: 1)
      end

      it 'redirects to login' do
        delete item_path(@item)
        expect(response).to redirect_to(login_path)
      end

      it 'does not delete item' do
        expect do
          delete item_path(1)
        end.to change(Item, :count).by(0)
      end
    end

    describe 'when user is logged in' do
      before :each do
        Product.create(name: 'test', price: 1, description: 'test')
        log_in_user
        @item = Item.create(product_id: 1, cart_id: 1, quantity: 1)
      end

      it 'redirects to root if item does not exist' do
        expect do
          delete item_path(-1)
        end.to change(Item, :count).by(0)
        expect(response).to redirect_to root_path
      end

      it 'redirects to root if item does not belong to user' do
        user = create(:admin)
        item = Item.create(product_id: 1, cart_id: user.cart.id, quantity: 1)
        expect do
          delete item_path(item)
        end.to change(Item, :count).by(0)
        expect(response).to redirect_to root_path
      end

      it 'deletes item if it exists and belongs to user' do
        expect do
          delete item_path(@item)
        end.to change(Item, :count).by(-1)
        expect(response).to redirect_to carts_path
      end
    end
  end

  describe 'POST /items/:id/add' do
    describe 'when user is not logged in' do
      before :each do
        Product.create(name: 'test', price: 1, description: 'test')
        create(:user)
        @item = Item.create(product_id: 1, cart_id: 1, quantity: 1)
      end

      it 'redirects to login' do
        post add_item_path(@item)
        expect(response).to redirect_to(login_path)
      end

      it 'does not update item' do
        expect do
          post add_item_path(@item)
        end.to change { @item.reload.quantity }.by(0)
      end
    end

    describe 'when user is logged in' do
      before :each do
        Product.create(name: 'test', price: 1, description: 'test')
        log_in_user
        @item = Item.create(product_id: 1, cart_id: 1, quantity: 1)
      end

      it 'redirects to root if item does not exist' do
        post add_item_path(-1)
        expect(response).to redirect_to root_path
      end

      it 'redirects to root if item does not belong to user' do
        user = create(:admin)
        i = Item.create(product_id: 1, cart_id: user.cart.id, quantity: 1)
        expect do
          post add_item_path(i)
        end.to change { i.reload.quantity }.by(0)
        expect(response).to redirect_to root_path
      end

      it 'updates items quantity if it exists and belongs to user' do
        expect do
          post add_item_path(@item)
        end.to change { @item.reload.quantity }.by(1)
        expect(response).to redirect_to carts_path
      end
    end
  end

  describe 'DELETE /items/:id/remove' do
    describe 'when user is not logged in' do
      before :each do
        Product.create(name: 'test', price: 1, description: 'test')
        create(:user)
        @item = Item.create(product_id: 1, cart_id: 1, quantity: 1)
      end

      it 'redirects to login' do
        delete remove_item_path(@item)
        expect(response).to redirect_to(login_path)
      end

      it 'does not update item' do
        expect do
          delete remove_item_path(@item)
        end.to change { @item.reload.quantity }.by(0)
      end
    end

    describe 'when user is logged in' do
      before :each do
        Product.create(name: 'test', price: 1, description: 'test')
        log_in_user
        @item = Item.create(product_id: 1, cart_id: 1, quantity: 1)
      end

      it 'redirects to root if item does not exist' do
        delete remove_item_path(-1)
        expect(response).to redirect_to root_path
      end

      it 'redirects to root if item does not belong to user' do
        user = create(:admin)
        i = Item.create(product_id: 1, cart_id: user.cart.id, quantity: 1)
        expect do
          delete remove_item_path(i)
        end.to change { i.reload.quantity }.by(0)
        expect(response).to redirect_to root_path
      end

      it 'updates quantity if its >1 and item belongs to user' do
        @item.update_attribute(:quantity, 5)
        expect do
          delete remove_item_path(@item)
        end.to change { @item.reload.quantity }.by(-1)
        expect(response).to redirect_to carts_path
      end

      it 'does not update quantity if its 1 and item belongs to user' do
        expect do
          delete remove_item_path(@item)
        end.to change { @item.reload.quantity }.by(0)
        expect(response).to redirect_to carts_path
      end
    end
  end

  describe 'POST /cart/add/:product_id' do
    it 'redirects to login if user is not logged in' do
      create(:product)
      post cart_add_path(1)
      expect(response).to redirect_to(login_path)
    end

    it 'redirects to root if product does not exist' do
      log_in_user
      post cart_add_path(-1)
      expect(response).to redirect_to root_path
    end

    it 'adds item to cart if product exists and user is logged in' do
      log_in_user
      create(:product)
      expect do
        post cart_add_path(1)
      end.to change(Item, :count).by(1)
      expect(response).to redirect_to carts_path
    end
  end
end
