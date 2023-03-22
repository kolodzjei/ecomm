# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :cart, optional: true
  belongs_to :product

  def total_price
    product.price * quantity
  end
end
