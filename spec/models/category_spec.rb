# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Category, type: :model) do
  describe "validations" do
    it "validates presence of name" do
      category = Category.new
      category.valid?
      expect(category.errors[:name]).to(include("can't be blank"))
    end

    it "validates uniqueness of name" do
      Category.create(name: "test")
      category = Category.new(name: "test")
      category.valid?
      expect(category.errors[:name]).to(include("has already been taken"))
    end
  end
end
