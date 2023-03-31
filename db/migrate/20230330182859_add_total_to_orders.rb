# frozen_string_literal: true

class AddTotalToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column(:orders, :total, :decimal, null: false)
  end
end