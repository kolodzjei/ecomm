# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Product, type: :model) do
  describe "validations" do
    it "is valid with valid attributes" do
      product = Product.new(name: "Product", description: "Description", price: 1)
      expect(product).to(be_valid)
    end

    it "is not valid without a name" do
      product = Product.new(name: nil, description: "Description", price: 1)
      expect(product).to_not(be_valid)
    end

    it "is not valid without a description" do
      product = Product.new(name: "Product", description: nil, price: 1)
      expect(product).to_not(be_valid)
    end

    it "is not valid without a price" do
      product = Product.new(name: "Product", description: "Description", price: nil)
      expect(product).to_not(be_valid)
    end

    it "is not valid with a name less than 3 characters" do
      product = Product.new(name: "Pr", description: "Description", price: 1)
      expect(product).to_not(be_valid)
    end

    it "is not valid with a name more than 50 characters" do
      name = "a" * 51
      product = Product.new(name:, description: "Description", price: 1)
      expect(product).to_not(be_valid)
    end

    it "is not valid with a description more than 500 characters" do
      description = "a" * 501
      product = Product.new(name: "Product", description:, price: 1)
      expect(product).to_not(be_valid)
    end

    it "is not valid with a price equal to 0" do
      product = Product.new(name: "Product", description: "Description", price: 0)
      expect(product).to_not(be_valid)
    end

    it "is not valid with a price less than 0" do
      product = Product.new(name: "Product", description: "Description", price: -1)
      expect(product).to_not(be_valid)
    end
  end
end
