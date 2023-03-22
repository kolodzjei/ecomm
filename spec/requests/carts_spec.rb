# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Carts', type: :request do
  describe 'GET /carts/:id' do
    it 'redirects to login if user is not logged in' do
      get cart_path(1)
      expect(response).to redirect_to(login_path)
    end

    it 'redirects to own cart if user is logged in' do
      log_in_user
      get cart_path(3)
      expect(response).to redirect_to(cart_path(1))
    end

    it 'renders cart if user is logged in and owns cart' do
      log_in_user
      get cart_path(1)
      expect(response).to have_http_status(200)
    end
  end
end
