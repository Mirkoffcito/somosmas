# frozen_string_literal: true

FactoryBot.define do
  factory :organization do
    name { Faker::Company.name }
    address { Faker::Address.street_name }
    phone { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email }
    welcome_text { Faker::Company.catch_phrase }
    about_us_text { Faker::Company.bs }
    facebook_url {Faker::Internet.url}
    instagram_url {Faker::Internet.url}
    linkedin_url {Faker::Internet.url}
  end
end
