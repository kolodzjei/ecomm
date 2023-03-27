# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    quantity { 1 }

    trait :with_user_and_product do
      cart { create(:user).cart }
      product { create(:product) }
    end

    trait :with_specific_user_and_product do
      transient do
        cart_id { nil }
        product_id { nil }
      end

      before(:create) do |item, evaluator|
        item.cart_id = evaluator.cart_id
        item.product_id = evaluator.product_id
      end
    end
  end
end
