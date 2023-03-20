# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'GET /login' do
    it 'returns successful response' do
      get login_path
      expect(response).to have_http_status(:success)
    end

    it 'redirects to root if already logged in' do
      log_in_user
      get login_path
      expect(response).to redirect_to root_path
    end
  end

  describe 'POST /login' do
    it 'logs in with valid credentials' do
      user = create(:user)
      post login_path, params: { user: { email: user.email, password: 'password' } }
      expect(response).to redirect_to root_path
      expect(flash[:notice]).to eq('You are now logged in.')
    end

    it 'does not log in with invalid credentials' do
      user = create(:user)
      post login_path, params: { user: { email: user.email, password: 'wrong' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(flash[:alert]).to eq('Invalid email or password.')
    end
  end

  describe 'DELETE /logout' do
    it 'logs out' do
      log_in_user
      delete logout_path
      expect(response).to redirect_to root_path
      expect(flash[:notice]).to eq('You are now logged out.')
    end
  end
end
