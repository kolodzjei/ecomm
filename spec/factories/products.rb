# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name { "Test product" }
    description { "Beautiful description for beautiful product" }
    price { "9.99" }
  end

  factory :random_product, class: Product do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.paragraph }
    price { Faker::Commerce.price }
  end
end
