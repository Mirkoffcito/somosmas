FactoryBot.define do 
    
    factory :user do
        email {Faker::Internet.email}
        first_name {Faker::Name.first_name}
        last_name {Faker::Name.last_name}
        password { Faker::Internet.password }
        password_confirmation {password}
    end

    factory :admin_user, parent: :user do
        role { create(:admin) }
    end 

    factory :client_user, parent: :user do
        role { create(:client) }
    end
end