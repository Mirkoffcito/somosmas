# frozen_string_literal: true

FactoryBot.define do
  factory :slide, class: 'Slide' do
  text { Faker::Lorem.paragraph(sentence_count: 2) }
  # order {}
  # sequence(:order) { |n| slide.id {n} }
  organization_id {}
  image {}
  # image { Rack::Test::UploadedFile.new(Rails.root.join("spec", "resources", "unafoto.png")) }
  # image { Faker::Avatar.image }
  # image { 'https://alkemy-ong.s3.sa-east-1.amazonaws.com/uxrs87xqspvb1krpupgxkgj39xn4?response-content-disposition=inline%3B%20filename%3D%22LOGO-SOMOS%20MAS.png%22%3B%20filename%2A%3DUTF-8%27%27LOGO-SOMOS%2520MAS.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAX2K6IMK7DAIQ6TDG%2F20210715%2Fsa-east-1%2Fs3%2Faws4_request&X-Amz-Date=20210715T003555Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=009f45d69407251c1c6283b68ec898440d4315cfbdaa1f65f672f4a765a183fa' }
  end
  end