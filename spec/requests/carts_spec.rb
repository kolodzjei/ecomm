# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Carts', type: :request do
  describe 'GET /cart' do
    it 'redirects to login if user is not logged in' do
      get carts_path
      expect(response).to redirect_to(login_path)
    end

    it 'renders cart if user is logged in' do
      log_in_user
      get carts_path
      expect(response).to have_http_status(200)
    end
  end
end
