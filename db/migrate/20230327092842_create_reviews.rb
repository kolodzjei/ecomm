# frozen_string_literal: true

class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table(:reviews) do |t|
      t.integer(:rating, null: false)
      t.string(:content)
      t.references(:user, null: false, foreign_key: true)
      t.references(:product, null: false, foreign_key: true)

      t.timestamps
    end
  end
end
