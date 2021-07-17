FactoryBot.define do
  factory :chat_user do
    user_id {}
    chat_id {}

    trait :with_admin_user do
      association :user, factory: [:user, :admin_user]
      chat_id {}
    end
  end
end
