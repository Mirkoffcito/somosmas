FactoryBot.define do 

    factory :admin_user, class: 'User' do
      email {Faker::Internet.email}
      first_name {Faker::Name.first_name}
      last_name {Faker::Name.last_name}
      password {"12345678"}
      password_confirmation {"12345678"}
      role_id {Role.where(name: 'admin').first&.id}
    end
  
    factory :client_user, class: 'User' do
      email {Faker::Internet.email}
      first_name {Faker::Name.first_name}
      last_name {Faker::Name.last_name}
      password {"12345678"}
      password_confirmation {"12345678"}
      role_id {Role.where(name: 'client').first&.id}
    end
  
  end