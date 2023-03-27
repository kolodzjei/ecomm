# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:user) { create(:user) }
  let(:product) { create(:product) }
  let(:item) { create(:item, :with_specific_user_and_product, cart_id: user.cart.id, product_id: product.id) }
  let(:order) { create(:order, user:, items: [item]) }

  describe 'associations' do
    it 'has many items' do
      expect(Order.reflect_on_association(:items).macro).to eq(:has_many)
    end

    it 'belongs to user' do
      expect(Order.reflect_on_association(:user).macro).to eq(:belongs_to)
    end

    it 'destroys items when order is destroyed' do
      order
      expect { order.destroy }.to change { Item.count }.by(-1)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(order).to be_valid
    end

    it 'is not valid without a shipping name' do
      order.shipping_name = nil
      expect(order).to_not be_valid
    end

    it 'is not valid without a shipping address line 1' do
      order.shipping_address_line_1 = nil
      expect(order).to_not be_valid
    end

    it 'is not valid without a shipping city' do
      order.shipping_city = nil
      expect(order).to_not be_valid
    end

    it 'is not valid without a shipping zipcode' do
      order.shipping_zipcode = nil
      expect(order).to_not be_valid
    end

    it 'is not valid without a shipping country' do
      order.shipping_country = nil
      expect(order).to_not be_valid
    end
  end

  describe 'methods' do
    it 'calculates total' do
      expect(order.total).to eq(product.price)
    end

    it 'cancels order' do
      order.cancel
      expect(order.status).to eq('cancelled')
    end

    it 'ships order' do
      order.ship
      expect(order.status).to eq('shipped')
    end

    it 'receives order' do
      order.receive
      expect(order.status).to eq('received')
    end

    it 'pays order' do
      order.pay
      expect(order.status).to eq('paid')
    end
  end
end
