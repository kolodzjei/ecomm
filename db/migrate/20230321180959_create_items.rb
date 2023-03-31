# frozen_string_literal: true

class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table(:items) do |t|
      t.integer(:quantity, default: 1)
      t.references(:cart, null: true, foreign_key: true)
      t.references(:product, null: false, foreign_key: true)

      t.timestamps
    end
  end
end
