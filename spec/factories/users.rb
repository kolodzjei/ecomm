# frozen_string_literal: true

FactoryBot.define do
  factory :user2, class: User do
    name { "John Doe" }
    email { "user-2@example.com" }
    password { "password" }
    password_confirmation { "password" }
    confirmed_at { Time.zone.now }
    admin { false }
  end

  factory :admin2, class: User do
    name { "Admin User" }
    email { "admin@example.com" }
    password_digest { BCrypt::Password.create("password") }
    confirmed_at { Time.zone.now }
    admin { true }
  end

  factory :user, class: User do
    name { "John Doe" }
    email { "user@example.com" }
    password { "password" }
    password_confirmation { "password" }
    confirmed_at { Time.zone.now }
    admin { false }
  end

  factory :admin, class: User do
    name { "Admin User" }
    email { "admin@example.com" }
    password { "password" }
    password_confirmation { "password" }
    confirmed_at { Time.zone.now }
    admin { true }
  end

  factory :random_user, class: User do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }
    confirmed_at { Time.zone.now }
    admin { false }
  end
end
