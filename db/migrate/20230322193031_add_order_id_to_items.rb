# frozen_string_literal: true

class AddOrderIdToItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :items, :order, null: true, foreign_key: true
  end
end
