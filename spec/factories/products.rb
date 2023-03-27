# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name { 'Test product' }
    description { 'Beautiful description for beautiful product' }
    price { '9.99' }
  end
end
