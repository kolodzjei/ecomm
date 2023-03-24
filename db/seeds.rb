# frozen_string_literal: true

User.create!(name: 'Example User',
             email: 'user@example.com',
             password: 'foobar',
             password_confirmation: 'foobar',
             admin: true,
             confirmed_at: Time.zone.now)

15.times do
  Category.create!(name: Faker::Commerce.unique.department(max: 1))
end

180.times do |n|
  p = Product.create!(name: "Product #{n + 1}",
                      description: Faker::Lorem.paragraph(sentence_count: 6),
                      price: Faker::Number.decimal(l_digits: 2))
  p.categories << Category.all.sample(rand(1..3))
end
