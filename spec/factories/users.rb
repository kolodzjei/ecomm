# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'John Doe' }
    email { 'user@example.com' }
    password_digest { BCrypt::Password.create('password') }
    confirmed_at { Time.zone.now }
  end
end
