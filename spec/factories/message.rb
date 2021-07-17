# frozen_string_literal: true

FactoryBot.define do
  factory :messages, class: 'Message' do
    detail { Faker::Lorem.sentence(word_count: 3) }
    modified { false }
    user_id {}
    chat_id {}
  end
end