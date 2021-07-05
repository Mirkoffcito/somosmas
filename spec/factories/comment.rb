# frozen_string_literal: true

FactoryBot.define do
  factory :comments, class: 'Comment' do
    content { Faker::Lorem.paragraph(sentence_count: 2) }
    user_id {}
    new_id {}
  end
end
