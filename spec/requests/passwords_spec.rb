# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Passwords', type: :request do
  let(:user) { create(:user) }
  describe 'GET /passwords/new' do
    it 'returns http success' do
      get new_password_path
      expect(response).to have_http_status(:success)
    end

    it 'redirects to root if logged in' do
      login_as user
      get new_password_path
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq('You are already logged in.')
    end
  end

  describe 'POST /passwords' do
    it 'sends password reset email if user exists' do
      post passwords_path, params: { user: { email: user.email } }
      expect(response).to redirect_to root_path
      expect(flash[:notice]).to eq('Check your email for password reset instructions.')
      expect(ActionMailer::Base.deliveries.last.to).to eq([user.email])
    end

    it 'does not send password reset email if user does not exist' do
      post passwords_path, params: { user: { email: 'notvalid@example.com' } }
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq('We could not find a user with that email.')
    end

    it 'does not send password reset email if user is not confirmed' do
      User.create(name: 'userexample', email: 'userexample@example.com', password: 'password',
                  password_confirmation: 'password')
      post passwords_path, params: { user: { email: 'userexample@example.com' } }
      expect(response).to redirect_to new_confirmation_path
      expect(flash[:alert]).to eq('Please confirm your email first.')
    end
  end

  describe 'GET /passwords/:password_reset_token/edit' do
    it 'renders edit template if token is valid' do
      mail = user.send_password_reset_email!
      get edit_password_path(mail.body.parts[0].body.raw_source.split('/')[-2])
      expect(response).to have_http_status(:success)
    end

    it 'redirects to root if token is invalid' do
      get edit_password_path('invalid_token')
      expect(response).to redirect_to new_password_path
      expect(flash[:alert]).to eq('Invalid token.')
    end

    it 'redirects if user is not confirmed' do
      example = User.create(name: 'userexample', email: 'userexample@example.com', password: 'password',
                            password_confirmation: 'password')

      mail = example.send_password_reset_email!
      get edit_password_path(mail.body.parts[0].body.raw_source.split('/')[-2])
      expect(response).to redirect_to new_confirmation_path
      expect(flash[:alert]).to eq('Please confirm your email first.')
    end
  end
end
