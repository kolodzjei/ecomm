# frozen_string_literal: true

class Cart < ApplicationRecord
  belongs_to :user
  has_many :items, dependent: :destroy
  has_many :products, through: :items

  def subtotal
    items.map(&:total_price).sum
  end

  def shipping
    9.99
  end

  def total
    subtotal + shipping
  end
end
