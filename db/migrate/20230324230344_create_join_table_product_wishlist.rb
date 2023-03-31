# frozen_string_literal: true

class CreateJoinTableProductWishlist < ActiveRecord::Migration[7.0]
  def change
    create_join_table(:products, :wishlists) do |t|
      t.index([:product_id, :wishlist_id])
      t.index([:wishlist_id, :product_id])
    end
  end
end
