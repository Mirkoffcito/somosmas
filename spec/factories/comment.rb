FactoryBot.define do
  factory :comments, class: 'Comment' do
    content { Faker::Lorem.sentence(word_count: 2 )}
    user_id {}
    new_id {}
  end
end
