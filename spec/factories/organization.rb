FactoryBot.define do
  factory :organization do
    name {Faker::Company.name}
    email {Faker::Internet.email}
    welcome_text {Faker::Company.catch_phrase}
    address {"Somos mas"}
    phone {"011123312354"}
  end
end
    