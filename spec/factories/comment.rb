FactoryBot.define do
  byebug
  factory :comments, class: 'Comment' do
    content { Faker::Lorem.sentence(word_count: 2 )}
    association: user_id
    association: new_id
  end
end
