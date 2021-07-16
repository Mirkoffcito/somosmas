FactoryBot.define do
  factory :message do
    detail { "MyText" }
    modified { false }
    user { nil }
    chat { nil }
    deleted_at { "2021-07-16 14:48:25" }
  end
end
