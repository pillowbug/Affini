require 'faker'

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
puts "Added #{User.last.first_name}"

# Three connections

puts "Seeding Connections"

Connection.create!({
  first_name: "Tom",
  last_name: "Niblo",
  frequency: 1.week,
  birthday: Faker::Date.in_date_period.strftime("%d %B"),
  description: "le wagon",
  user_id: User.last.id
})
Connection.create!({
  first_name: "Gerard",
  last_name: "Cabarse",
  frequency: 1.month,
  birthday: Faker::Date.in_date_period.strftime("%d %B"),
  description: "le wagon",
  user_id: User.last.id
})
Connection.create!({
  first_name: "Jiyoung",
  last_name: "Ko",
  frequency: 1.year,
  birthday: Faker::Date.in_date_period.strftime("%d %B"),
  description: "le wagon",
  user_id: User.last.id
})
Connection.create!({
  first_name: "Maxime",
  last_name: "Froment",
  frequency: nil,
  birthday: Faker::Date.in_date_period.strftime("%d %B"),
  description: "le wagon",
  user_id: User.last.id
})
puts "Added #{Connection.all.count} connections"

# Checkin

puts "Seeding Checkin"

10.times do

  time = Faker::Time.between(from: 5.days.ago, to: 5.days.from_now).to_datetime
  args = {
    user_id: User.last.id,
    rating: [1..5].sample,
    time: time,
    completed: (time.future? ? false : [true, false].sample),
    description: 'le wagon'
  }
  checkin = Checkin.new(args)
  checkin.connections << Connection.all.sample(rand(1..2))
  checkin.save!
end
puts "Added #{Checkin.count} checkin"

