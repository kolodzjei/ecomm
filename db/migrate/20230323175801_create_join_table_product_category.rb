# frozen_string_literal: true

class CreateJoinTableProductCategory < ActiveRecord::Migration[7.0]
  def change
    create_join_table :products, :categories do |t|
      t.index %i[product_id category_id]
      t.index %i[category_id product_id]
    end
  end
end
