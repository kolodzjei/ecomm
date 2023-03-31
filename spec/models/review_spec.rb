# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Review, type: :model) do
  let(:user) { create(:user) }
  let(:product) { create(:product) }

  describe "validations" do
    before :each do
      @review = Review.new(rating: 5, content: "Great product", product_id: product.id, user_id: user.id)
    end

    it "is valid with valid attributes" do
      expect(@review).to(be_valid)
    end

    it "is not valid without a rating" do
      @review.rating = nil
      expect(@review).to_not(be_valid)
    end

    it "is not valid with rating less than 1" do
      @review.rating = 0
      expect(@review).to_not(be_valid)
    end

    it "is not valid with rating greater than 5" do
      @review.rating = 6
      expect(@review).to_not(be_valid)
    end

    it "is not valid with too long content" do
      @review.content = "a" * 1001
      expect(@review).to_not(be_valid)
    end

    it "is not valid without a user" do
      @review.user_id = nil
      expect(@review).to_not(be_valid)
    end

    it "is not valid without a product" do
      @review.product_id = nil
      expect(@review).to_not(be_valid)
    end
  end
end
