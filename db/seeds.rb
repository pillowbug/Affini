require 'faker'

puts "Destroying Existing DB"
Tag.destroy_all
User.destroy_all
Connection.destroy_all
Checkin.destroy_all
Glance.destroy_all


puts "Seeding Tags"

Tag.create!({ value: 'school'})
Tag.create!({ value: 'work'})
Tag.create!({ value: 'sports'})
Tag.create!({ value: 'music'})
Tag.create!({ value: 'family'})
Tag.create!({ value: 'acquaintance'})
Tag.create!({ value: 'friend'})

puts "Added #{Tag.count} tags"


# User
puts "Seeding User"
usr = User.create!({
    first_name: 'Don',
    last_name: 'Tillman',
    email: "dontillman@org",
    password: 'secret'
})
puts "Added #{usr.first_name}"

# Three connections

puts "Seeding Connections"

Connection.create!({
  first_name: "Tom",
  last_name: "Niblo",
  frequency: 1.week,
  birthday: Faker::Date.in_date_period.strftime("%d %B"),
  description: "Coding Scot",
  user_id: usr.id,
  linkedin: 'https://www.linkedin.com/in/lum555/',
  instagram: 'https://www.instagram.com/tlum555/',
  remote_photo_url: 'https://avatars1.githubusercontent.com/u/53204738?s=460&v=4'
})
Connection.create!({
  first_name: "Gerard",
  last_name: "Cabarse",
  frequency: 1.month,
  birthday: Faker::Date.in_date_period.strftime("%d %B"),
  description: "Description goes here",
  user_id: usr.id,
  instagram: 'https://www.instagram.com/gerardishere/',
  remote_photo_url: 'https://avatars0.githubusercontent.com/u/16109822?s=460&v=4'
})
Connection.create!({
  first_name: "Jiyoung",
  last_name: "Ko",
  frequency: 1.year,
  birthday: Faker::Date.in_date_period.strftime("%d %B"),
  description: "Description goes here",
  user_id: usr.id,
  facebook: 'https://www.facebook.com/jko420',
  instagram: 'https://www.instagram.com/jy_ko/',
  email: 'jiyoung@ko.org',
  remote_photo_url: 'https://avatars0.githubusercontent.com/u/53289659?s=460&v=4'
})
Connection.create!({
  first_name: "Maxime",
  last_name: "Froment",
  frequency: nil,
  birthday: Faker::Date.in_date_period.strftime("%d %B"),
  description: "Description goes here",
  user_id: usr.id,
  linkedin: 'https://www.linkedin.com/in/maxime-froment-99457a2/',
  email: 'maxime@froment.org',
  remote_photo_url: 'https://avatars3.githubusercontent.com/u/20883030?s=460&v=4'
})
puts "Added #{Connection.all.count} connections"

# Checkin

puts "Seeding Checkin"

10.times do

  time = Faker::Time.between(from: 5.days.ago, to: 5.days.from_now).to_datetime
  args = {
    user_id: usr.id,
    rating: [1..5].sample,
    time: time,
    completed: (time.future? ? false : [true, false].sample),
    description: 'Description goes here'
  }
  checkin = Checkin.new(args)
  checkin.connections << Connection.all.sample(rand(1..2))
  checkin.save!
end
puts "Added #{Checkin.count} checkins"

#Glance
puts "Seeding Glances"

Glance.create!({
  question: 'Favourite Food?',
  answer: 'Mushroom',
  connection_id: 1
})
Glance.create!({
  question: 'Favourite Food?',
  answer: 'Red Bean Bun',
  connection_id: 2
})
Glance.create!({
  question: 'Celebrity Crush?',
  answer: 'Hyuna',
  connection_id: 2
})
Glance.create!({
  question: 'Favourite Food?',
  answer: 'Pizza',
  connection_id: 3
})
Glance.create!({
  question: 'Favourite Food?',
  answer: 'Foie gras',
  connection_id: 4
})

puts "Added #{Glance.count} glances"

Connection.find(1).tag_ids = [3 , 5]
Connection.find(2).tag_ids = [1, 2, 3]
Connection.find(3).tag_ids = 4
Connection.find(4).tag_ids = 5
