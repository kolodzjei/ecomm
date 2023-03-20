# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  before :each do
    @user = User.new(name: 'Example', email: 'user@example.com', password: 'password',
                     password_confirmation: 'password')
  end

  it 'is valid with valid attributes' do
    expect(@user).to be_valid
  end

  it 'is not valid without a name' do
    @user.name = nil
    expect(@user).not_to be_valid
  end

  it 'is not valid without an email' do
    @user.email = nil
    expect(@user).not_to be_valid
  end

  it 'is not valid with too long name' do
    @user.name = 'a' * 51
    expect(@user).not_to be_valid
  end

  it 'should have a unique email' do
    duplicate_user = @user.dup
    @user.save
    expect(duplicate_user).not_to be_valid
  end

  it 'should save email as lower-case' do
    email = 'UseR@eXamPLe.cOm'
    @user.email = email
    @user.save
    expect(@user.reload.email).to eq email.downcase
  end

  it 'should not be confirmed by default' do
    expect(@user.confirmed?).to be false
  end

  it 'should be confirmed after confirmation' do
    @user.save
    @user.confirm!
    expect(@user.confirmed?).to be true
  end

  it 'sends a confirmation email' do
    expect { @user.send_confirmation_email! }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it 'sends a password reset email' do
    expect { @user.send_password_reset_email! }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it 'should be reconfirming if unconfirmed_email is present' do
    @user.unconfirmed_email = 'user-2@example.com'
    expect(@user.reconfirming?).to be true
  end
end
