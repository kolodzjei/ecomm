# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'associations' do
    it 'belongs to cart' do
      expect(Item.reflect_on_association(:cart).macro).to eq(:belongs_to)
    end

    it 'belongs to product' do
      expect(Item.reflect_on_association(:product).macro).to eq(:belongs_to)
    end
  end

  describe 'methods' do
    it 'calculates total price' do
      create(:product)
      item = Item.new(product_id: 1, quantity: 2)
      expect(item.total_price).to eq(Product.first.price * 2)
    end
  end
end
