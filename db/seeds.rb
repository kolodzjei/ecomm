# frozen_string_literal: true

User.create!(name: 'Example User',
             email: 'user@example.com',
             password: 'foobar',
             password_confirmation: 'foobar',
             admin: true,
             confirmed_at: Time.zone.now)

10.times do |n|
  Product.create!(name: "Product #{n}",
                  description: Faker::Lorem.paragraph(sentence_count: 6),
                  price: Faker::Number.decimal(l_digits: 2))
end
