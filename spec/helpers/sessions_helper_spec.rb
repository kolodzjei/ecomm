# frozen_string_literal: true

require "rails_helper"

# Specs in this file have access to a helper object that includes
# the SessionsHelper. For example:
#
# describe SessionsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe(SessionsHelper, type: :helper) do
  describe "#current_user" do
    it "returns nil if no user is logged in" do
      expect(helper.current_user).to(be_nil)
    end

    # it 'returns the current user if a user is logged in' do
    #
    #   expect(helper.current_user).to eq(user)
    # end
  end

  describe "#logged_in?" do
    it "returns false if no user is logged in" do
      expect(helper.logged_in?).to(be_falsey)
    end
  end
end
