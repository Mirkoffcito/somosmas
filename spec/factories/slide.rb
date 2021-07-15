# frozen_string_literal: true

FactoryBot.define do
  factory :slide, class: 'Slide' do
    text { Faker::Lorem.paragraph(sentence_count: 2) }
    order {}
    organization_id {}
    image {}
  end
end