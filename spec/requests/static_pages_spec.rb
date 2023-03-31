# frozen_string_literal: true

require "rails_helper"

RSpec.describe("StaticPages", type: :request) do
  describe "get root_path" do
    it "returns sucessfully" do
      get root_path
      expect(response).to(have_http_status(200))
    end
  end
end
