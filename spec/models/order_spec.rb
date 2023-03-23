# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'associations' do
    it 'has many items' do
      expect(Order.reflect_on_association(:items).macro).to eq(:has_many)
    end

    it 'belongs to user' do
      expect(Order.reflect_on_association(:user).macro).to eq(:belongs_to)
    end

    it 'destroys items when order is destroyed' do
      user = create(:user)
      order = create(:order)
      product = create(:product)
      i = Item.create(product:, quantity: 1, order:)
      expect { order.destroy }.to change { Item.count }.by(-1)
    end
  end

  describe 'validations' do
    before :each do
      @user = create(:user)
      @order = build(:order)
      @order.user_id = @user.id
    end

    it 'is valid with valid attributes' do
      expect(@order).to be_valid
    end

    it 'is not valid without a shipping name' do
      @order.shipping_name = nil
      expect(@order).to_not be_valid
    end

    it 'is not valid without a shipping address line 1' do
      @order.shipping_address_line_1 = nil
      expect(@order).to_not be_valid
    end

    it 'is not valid without a shipping city' do
      @order.shipping_city = nil
      expect(@order).to_not be_valid
    end

    it 'is not valid without a shipping zipcode' do
      @order.shipping_zipcode = nil
      expect(@order).to_not be_valid
    end

    it 'is not valid without a shipping country' do
      @order.shipping_country = nil
      expect(@order).to_not be_valid
    end
  end

  describe 'methods' do
    before :each do
      @user = create(:user)
      @order = create(:order)
      @order.user_id = @user.id
      @product = create(:product)
      @item = Item.create(product: @product, quantity: 1, order: @order)
    end

    it 'calculates total' do
      expect(@order.total).to eq(@product.price)
    end

    it 'cancels order' do
      @order.cancel
      expect(@order.status).to eq('cancelled')
    end

    it 'ships order' do
      @order.ship
      expect(@order.status).to eq('shipped')
    end

    it 'receives order' do
      @order.receive
      expect(@order.status).to eq('received')
    end

    it 'pays order' do
      @order.pay
      expect(@order.status).to eq('paid')
    end
  end
end
