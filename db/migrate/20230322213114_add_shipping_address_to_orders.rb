# frozen_string_literal: true

class AddShippingAddressToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column(:orders, :shipping_name, :string, null: false)
    add_column(:orders, :shipping_address_line_1, :string, null: false)
    add_column(:orders, :shipping_address_line_2, :string)
    add_column(:orders, :shipping_city, :string, null: false)
    add_column(:orders, :shipping_zipcode, :string, null: false)
    add_column(:orders, :shipping_country, :string, null: false)
  end
end
