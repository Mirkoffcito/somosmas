FactoryBot.define do
  factory :chat_user do
    user_id {}
    chat_id {}

    trait :with_user do
      association :user, factory: :user
      chat_id {}
    end
  end
end
