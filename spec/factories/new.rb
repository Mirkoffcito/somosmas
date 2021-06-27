FactoryBot.define do

    factory :new, class: 'New' do
        name { Faker::Name.name }
        content{ Faker::Lorem.paragraph(sentence_count:10) }
        association :category, factory: :category
    end
  
end