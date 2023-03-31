# frozen_string_literal: true

class AddConfirmationToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column(:users, :confirmed_at, :datetime)
  end
end
