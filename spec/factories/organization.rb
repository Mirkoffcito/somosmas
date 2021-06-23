# frozen_string_literal: true

FactoryBot.define do
  factory :organization do
    name { Faker::Company.name }
    email { Faker::Internet.email }
    welcome_text { Faker::Company.catch_phrase }
    address { Faker::Address.street_name }
    phone { Faker::PhoneNumber.phone_number }
  end
end
