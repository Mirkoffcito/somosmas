FactoryBot.define do
  factory :testimonial, class: Testimonial do
    name {Faker::Lorem.sentences(number: 1)}
    content {Faker::Lorem.paragraph(sentence_count: 10)}
  end
end