FactoryBot.define do

    factory :category, class: 'Category' do
        name { Faker::Name.name }
        description{ Faker::Lorem.paragraph(sentence_count:2) }
    end
  
end