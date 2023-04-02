# frozen_string_literal: true

class Product < ApplicationRecord
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :wishlists
  has_many :reviews, dependent: :destroy
  has_many :items, dependent: :destroy
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :price, presence: true, numericality: { greater_than: 0, only_integer: false }
  has_one_attached :image do |attachable|
    attachable.variant(:thumb, resize_to_limit: [150, 150])
    attachable.variant(:medium, resize_to_limit: [300, 300])
    attachable.variant(:large, resize_to_limit: [500, 500])
  end
  validates :image,
    attached: false,
    content_type: { in: ["image/png", "image/jpg", "image/jpeg"], message: "must be a valid image format" },
    size: { less_than: 5.megabytes, message: "should be less than 5MB" }
  before_save :set_default_image
  scope :by_category, ->(category_ids) { joins(:categories).where(categories: { id: category_ids }).distinct }
  scope :by_search, ->(search) { where("products.name LIKE ?", "%#{search}%") }

  def self.search(params)
    all = Product.all
    all = all.by_category(params[:category_ids]) if params[:category_ids].present?
    all = all.by_search(params[:search]) if params[:search].present?
    all = case params[:sort_by]
    when "name" then all.order(name: :asc)
    when "name_desc" then all.order(name: :desc)
    when "price" then all.order(price: :asc)
    when "price_desc" then all.order(price: :desc)
    else all
    end
    all
  end

  def average_rating
    if reviews.count.positive?
      reviews.average(:rating).round(1)
    else
      0
    end
  end

  private

  def set_default_image
    return if image.attached?

    image.attach(
      io: File.open(Rails.root.join("app", "assets", "images", "default_product.png")),
      filename: "default_product.png",
      content_type: "image/png",
    )
  end
end
