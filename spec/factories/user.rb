FactoryBot.define do
  factory :admin_user, class: User do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { '123456' }
    password_confirmation { '123456' }
    role_id { '1' }
  end

  factory :client_user, class: User do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { '123456' }
    password_confirmation { '123456' }
    role_id { '2' }
  end

  factory :user, class: User do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { '123456' }
    password_confirmation { '123456' }
  end
end