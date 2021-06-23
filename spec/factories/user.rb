# frozen_string_literal: true

FactoryBot.define do

  factory :public_user, class: 'User' do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password { Faker::Internet.password(min_length: 6) }
    password_confirmation { password }
  end
  
  factory :admin_user, class: 'User' do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password { Faker::Internet.password(min_length: 6) }
    password_confirmation { password }
    role_id { Role.where(name: 'admin').first&.id }
  end

  factory :client_user, class: 'User' do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password { Faker::Internet.password(min_length: 8) }
    password_confirmation { password }
    role_id { Role.where(name: 'client').first&.id }
  end

end
