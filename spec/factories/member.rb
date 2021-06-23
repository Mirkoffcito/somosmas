FactoryBot.define do
  factory :member do
    name {Faker::Name.first_name}
    facebook_url {Faker::Internet.url}
    instagram_url {Faker::Internet.url}
    linkedin_url {Faker::Internet.url}
    description {Faker::Lorem.sentences}
  end

  factory :param_missing_member, class: 'Member' do
    facebook_url {Faker::Internet.url}
    instagram_url {Faker::Internet.url}
    linkedin_url {Faker::Internet.url}
    description {Faker::Lorem.sentences}
  end
end