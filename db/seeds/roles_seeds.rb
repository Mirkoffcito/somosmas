Role.destroy_all
ActiveRecord::Base.connection.reset_pk_sequence!('roles')

Role.create!(id:1, name:"admin")
Role.create!(id:2, name:"client")

p "Created #{Role.count} roles for 'Somos mas' organization"