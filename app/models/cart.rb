# frozen_string_literal: true

class Cart < ApplicationRecord
  belongs_to :user
  has_many :items, dependent: :destroy
  has_many :products, through: :items

  def subtotal
    items.map(&:total_price).sum
  end

  def shipping
    0.00
  end

  def total
    subtotal + shipping
  end
end
