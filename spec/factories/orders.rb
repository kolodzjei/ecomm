# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    user_id { 1 }
    shipping_name { 'MyString' }
    shipping_address_line_1 { 'MyString' }
    shipping_address_line_2 { 'MyString' }
    shipping_city { 'MyString' }
    shipping_zipcode { 'MyString' }
    shipping_country { 'MyString' }
    status { 0 }
  end
end
