FactoryBot.define do
  factory :message, class: 'Message' do
    detail { Faker::Lorem.sentence(word_count: 3) }
    modified { false }
    user_id {}
    chat_id {}
  end
end
