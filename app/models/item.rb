# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :cart, optional: true
  belongs_to :product
  belongs_to :order, optional: true

  def total_price
    product.price * quantity
  end
end
