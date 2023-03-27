# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    shipping_name { 'Test name' }
    shipping_address_line_1 { 'Test address 1' }
    shipping_address_line_2 { 'Test address 2' }
    shipping_city { 'Test city' }
    shipping_zipcode { 'Test zipcode' }
    shipping_country { 'Test country' }

    trait :with_specific_user_and_items do
      transient do
        user_id { nil }
        items { nil }
      end

      before(:create) do |order, evaluator|
        order.user_id = evaluator.user_id
        order.items = evaluator.items
      end
    end
  end
end
