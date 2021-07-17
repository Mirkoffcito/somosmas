FactoryBot.define do
  factory :chat_user do
    association :user, factory: :user
    chat_id {}
  end
end
