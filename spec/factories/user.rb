FactoryBot.define do 
    
    factory :user do
        email {Faker::Internet.email}
        first_name {Faker::Name.first_name}
        last_name {Faker::Name.last_name}
        password { Faker::Internet.password }
        password_confirmation {password}
        role_id { Role.where(name: 'admin').first&.id}
    end

end