# frozen_string_literal: true

class Order < ApplicationRecord
  has_many :items, dependent: :destroy
  belongs_to :user
  enum status: [:pending, :paid, :shipped, :cancelled, :received]
  default_scope -> { order(created_at: :desc) }
  validates :shipping_address_line_1, presence: true
  validates :shipping_country, presence: true
  validates :shipping_zipcode, presence: true
  validates :shipping_city, presence: true
  validates :shipping_name, presence: true
  validates :status, presence: true
  before_save :set_total

  def cancel
    self.status = :cancelled
  end

  def cancel!
    cancel
    save
  end

  def ship
    self.status = :shipped
  end

  def receive
    self.status = :received
  end

  def pay
    self.status = :paid
  end

  def paid?
    status != "pending" && status != "cancelled"
  end

  private

  def set_total
    self.total = items.map(&:total_price).sum if total.nil?
  end
end
