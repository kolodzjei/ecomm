# frozen_string_literal: true

FactoryBot.define do
  factory :review do
    rating { 5 }
    content { "Great product" }

    trait :with_specific_user_and_product do
      transient do
        user_id { nil }
        product_id { nil }
      end

      before(:create) do |order, evaluator|
        order.user_id = evaluator.user_id
        order.product_id = evaluator.product_id
      end
    end
  end
end
