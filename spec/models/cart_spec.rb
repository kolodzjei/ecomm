# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe 'associations' do
    it 'belongs to user' do
      expect(Cart.reflect_on_association(:user).macro).to eq(:belongs_to)
    end

    it 'has many items' do
      expect(Cart.reflect_on_association(:items).macro).to eq(:has_many)
    end

    it 'has many products' do
      expect(Cart.reflect_on_association(:products).macro).to eq(:has_many)
    end
  end

  describe 'methods' do
    it 'calculates subtotal' do
      user = create(:user)
      create(:product)
      expect(user.cart.subtotal).to eq(0)
      user.cart.items.create(product_id: 1, quantity: 1)
      expect(user.cart.subtotal).to eq(9.99)
    end

    # Will be uncommented when shipping is implemented
    #
    # it 'calculates shipping' do
    #   user = create(:user)
    #   expect(user.cart.shipping).to eq(0.00)
    # end

    # it 'calculates total' do
    #   user = create(:user)
    #   create(:product)
    #   expect(user.cart.total).to eq(9.99)
    #   user.cart.items.create(product_id: 1, quantity: 1)
    #   expect(user.cart.total).to eq(19.98)
    # end
  end
end
