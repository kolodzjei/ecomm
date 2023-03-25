# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Wishlist, type: :model do
  describe 'associations' do
    it 'belongs to user' do
      expect(Wishlist.reflect_on_association(:user).macro).to eq(:belongs_to)
    end
    
    it 'has and belongs to many products' do
      expect(Wishlist.reflect_on_association(:products).macro).to eq(:has_and_belongs_to_many)
    end
  end
end
