# frozen_string_literal: true

FactoryBot.define do 
  factory :contact, class: 'Contact' do
    name { Faker::Name.name }
    message { Faker::Lorem.paragraph(sentence_count:5) }
    email { Faker::Internet.email }
    user_id {}
  end
end 