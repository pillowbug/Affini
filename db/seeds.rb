# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts "Destroying Existing DB"
User.destroy_all
Connection.destroy_all
Checkin.destroy_all

# User
puts "Seeding User"
User.create!({
    first_name: 'Don',
    last_name: 'Tillman',
    email: "dontillman@org",
    password: 'secret',
})
puts " Added #{User.last.first_name}"

#Three connections

puts "Seeding Connections"
Connection.create!({
  first_name: "Tom",
  last_name: "Niblo",
  frequency: "once a week",
  description: "le wagon",
  user_id: User.last.id
})
Connection.create!({
  first_name: "Gerard",
  last_name: "Cabarse",
  frequency: "once a month",
  description: "le wagon",
  user_id: User.last.id
})
Connection.create!({
  first_name: "Jiyoung",
  last_name: "Ko",
  frequency: "once a year",
  description: "le wagon",
  user_id: User.last.id
})
Connection.create!({
  first_name: "Maxime",
  last_name: "Froment",
  frequency: "once a week",
  description: "le wagon",
  user_id: User.last.id
})
puts " Added #{Connection.all.count} connections"

#Checkin

puts "Seeding Checkin"
  Checkin.create!({
    user_id: User.last.id,
    rating: '1',
    time: Time.now,
    description: 'le wagon le wagon',
    completed: true
  })
puts " Added first checkin"
