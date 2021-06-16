Activity.destroy_all

10.times do
    Activity.create!([{
        name:Faker::Name.name,
        content:Faker::Lorem.paragraph(sentence_count:10)
    }])
end

p "Created #{Activity.count} activities for 'Somos mas' organization"