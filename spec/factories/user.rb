FactoryBot.define do 
    
    factory :user do
        email {Faker::Internet.email}
        first_name {Faker::Name.first_name}
        last_name {Faker::Name.last_name}
        password {"12345678"}
        password_confirmation {"12345678"}
    end

    factory :user_without_email, class:'User' do
        email {nil}
        first_name {Faker::Name.first_name}
        last_name {Faker::Name.last_name}
        password {"12345678"}
        password_confirmation {"12345678"}
    end

    factory :user_without_password_confirmation, class:'User' do
        email {Faker::Internet.email}
        first_name {Faker::Name.first_name}
        last_name {Faker::Name.last_name}
        password {"12345678"}
        password_confirmation {nil}
    end
end