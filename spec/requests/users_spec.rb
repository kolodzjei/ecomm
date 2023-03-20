# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /signup' do
    it 'returns successful response' do
      get signup_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /signup' do
    it 'creates a new user with valid credentials and redirects to root' do
      expect do
        post signup_path,
             params: { user: { name: 'Example user', email: 'user@example.com', password: 'password',
                               password_confirmation: 'password' } }
      end.to change(User, :count).by(1)
      expect(response).to redirect_to root_path
      expect(flash[:notice]).to eq('Please check your email for confirmation instructions.')
    end

    it 'does not create a new user with invalid credentials ' do
      expect do
        post signup_path,
             params: { user: { name: '', email: 'user@example.com', password: 'password',
                               password_confirmation: 'password' } }
      end.to change(User, :count).by(0)
      expect(response).to have_http_status(422)
      expect(response.body).to include('Name can&#39;t be blank')
    end
  end

  describe 'GET /profile' do
    it 'redirects to login page if not logged in' do
      get profile_path
      expect(response).to redirect_to login_path
      # expect(flash[:error]).to eq('You must be logged in to do that')
      # expect(response.body).to include('You must be logged in to do that')
    end

    it 'returns successful response if logged in' do
      log_in_user
      get profile_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'PUT /profile' do
    before :each do
      log_in_user
    end

    it 'does not update credentials with invalid current password' do
      put profile_path,
          params: { user: { current_password: 'wrong', password: 'newpassword', password_confirmation: 'newpassword' } }
      expect(response).to have_http_status(422)
      expect(flash[:error]).to eq('Incorrect password')
    end

    it 'updates credentials with valid current password' do
      put profile_path,
          params: { user: { current_password: 'password', password: 'newpassword',
                            password_confirmation: 'newpassword' } }
      expect(response).to redirect_to root_path
      expect(flash[:notice]).to eq('Your account has been updated.')
    end

    it 'does not update credentials with invalid new password' do
      put profile_path,
          params: { user: { current_password: 'password', password: 'new', password_confirmation: 'new' } }
      expect(response).to have_http_status(422)
    end

    it 'does not update credentials with mismatched new password' do
      put profile_path,
          params: { user: { current_password: 'password', password: 'newpassword',
                            password_confirmation: 'newpassword1' } }
      expect(response).to have_http_status(422)
    end

    it 'updates email with valid current password' do
      put profile_path, params: { user: { current_password: 'password', unconfirmed_email: 'user-second@example.com' } }
      expect(response).to redirect_to root_path
      expect(current_user.reconfirming?).to be true
      expect(current_user.unconfirmed_email).to eq 'user-second@example.com'
      expect(ActionMailer::Base.deliveries.last.to).to eq ['user-second@example.com']
    end
  end
end
