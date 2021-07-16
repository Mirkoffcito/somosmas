FactoryBot.define do
  factory :message do
    detail { "MyText" }
    modified { false }
    chat { nil }
    user { nil }
  end
end
