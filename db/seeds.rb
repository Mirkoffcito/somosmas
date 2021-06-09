# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

# Activities SEEDS data:
require 'faker'
Activity.destroy_all

10.times do
    Activity.create!([{
        name:Faker::Name.name,
        content:Faker::Lorem.paragraph(sentence_count:10)
    }])
end

p "Created #{Activity.count} activities for 'Somos mas' organization"