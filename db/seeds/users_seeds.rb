User.skip_callback(:create, :after, :send_mail)
users = User.all

users.each do |user|
    user.really_destroy!
end

10.times do |i|
    User.create!([{
        email:"AdminUser#{i}@somos-mas.org",
        first_name:Faker::Name.first_name,
        last_name:Faker::Name.last_name,
        role_id:1,
        password:"12345678",
        password_confirmation:"12345678",
        is_seed:"yes"
    }])
end

10.times do |i|
    User.create!([{
        email:"ClientUser#{i}@somos-mas.org",
        first_name:Faker::Name.first_name,
        last_name:Faker::Name.last_name,
        role_id:2,
        password:"12345678",
        password_confirmation:"12345678",
        is_seed:"yes"
    }])
end

p "Created #{User.count} users for 'Somos mas' organization"
