FactoryBot.define do
  factory :member, class: 'Member' do
    name {Faker::Name.first_name}
    facebook_url {Faker::Internet.url}
    instagram_url {Faker::Internet.url}
    linkedin_url {Faker::Internet.url}
    description {Faker::Quote.famous_last_words}
  end

end