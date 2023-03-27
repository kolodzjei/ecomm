# frozen_string_literal: true

class AddDisabledToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :disabled, :boolean, default: false
  end
end
