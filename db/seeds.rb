# frozen_string_literal: true

User.create!(
  name: "Example User",
  email: "user@example.com",
  password: "foobar",
  password_confirmation: "foobar",
  admin: true,
  confirmed_at: Time.zone.now,
)

10.times do |n|
  User.create!(
    name: "Example user #{n + 1}",
    email: "user-#{n + 1}@example.com",
    password: "foobar",
    password_confirmation: "foobar",
    admin: false,
    confirmed_at: Time.zone.now,
  )
end

10.times do
  Category.create!(name: Faker::Commerce.unique.department(max: 1))
end

30.times do |n|
  p = Product.create!(
    name: "Product #{n + 1}",
    description: Faker::Lorem.paragraph(sentence_count: 6),
    price: Faker::Number.decimal(l_digits: 2),
  )
  p.categories << Category.all.sample(rand(1..10))
end
