require 'faker'


def completed?(checkin)
  if checkin[:time].to_f > Time.now.to_f
    return false
  else
    return [true, false].sample
  end
end

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

#Three connections

puts "Seeding Connections"

Connection.create!({
  first_name: "Tom",
  last_name: "Niblo",
  frequency: "once a week",
  birthday: Faker::Date.in_date_period.strftime("%d %B"),
  description: "le wagon",
  user_id: User.last.id
})
Connection.create!({
  first_name: "Gerard",
  last_name: "Cabarse",
  frequency: "once a month",
  birthday: Faker::Date.in_date_period.strftime("%d %B"),
  description: "le wagon",
  user_id: User.last.id
})
Connection.create!({
  first_name: "Jiyoung",
  last_name: "Ko",
  frequency: "once a year",
  birthday: Faker::Date.in_date_period.strftime("%d %B"),
  description: "le wagon",
  user_id: User.last.id
})
Connection.create!({
  first_name: "Maxime",
  last_name: "Froment",
  frequency: "once a week",
  birthday: Faker::Date.in_date_period.strftime("%d %B"),
  description: "le wagon",
  user_id: User.last.id
})
puts "Added #{Connection.all.count} connections"

#Checkin

puts "Seeding Checkin"

10.times do
  args = {
    user_id: User.last.id,
    rating: [1..5].sample,
    time: Faker::Time.between_dates(from: Date.today - 5, to: Date.today + 5, format: :default),
    description: 'le wagon'
  }
  args.merge!({completed: completed?(args)})
  checkin = Checkin.new(args)
  checkin.connections << Connection.all.sample(rand(1..2))
  checkin.save
end
puts "Added #{Checkin.count} checkin"

