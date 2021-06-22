FactoryBot.define do 
    
    factory :user do
        email {Faker::Internet.email}
        first_name {Faker::Name.first_name}
        last_name {Faker::Name.last_name}
        password {"12345678"}
        password_confirmation {"12345678"}
    end

    factory :invalid_user, class:'User' do
        email {nil}
        first_name {Faker::Name.first_name}
        last_name {Faker::Name.last_name}
        password {"12345678"}
        password_confirmation {"12345678"}
    end
end