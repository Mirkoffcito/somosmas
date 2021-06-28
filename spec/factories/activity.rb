FactoryBot.define do 
  factory :activity do
    name {Faker::Name.name}
    content {Faker::Lorem.paragraph(sentence_count:10)}
  end
end