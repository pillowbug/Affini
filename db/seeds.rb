# -- utility --
class Hash
  def mslice
    # slice with 'public' keys ie those not prefixed with an underscore
    self.slice(*self.keys.reject { |k| k.start_with? '_' })
  end
end

class String
  def to_timeshift
    # TODO: implement safely '2.days.ago.noon + 6.hour'
    # nud = self.gsub(/\s+/,'').split('.')
    # raise ArgumentError, 'Not a time shift' unless nud.length >= 3
    # res = nud[0].to_i.send(nud[1]).send(nud[2])
    res = eval(self)
    raise ArgumentError, 'Not a time' unless res.is_a? ActiveSupport::TimeWithZone
    res
  end

  def to_yearless_date
    # use a leap year sufficiently in the past = 0000
    Date.parse(self + ' 0000')
    # TODO: discuss how we handle birthdays
  end
end

# -- seeding --
puts "Start seeding"
seed_data = {}
Dir[File.join(__dir__,'data','seed*.yml' )].each do |seed_file|
  YAML::load(ERB.new(File.read(seed_file)).result).each do |k, v|
    seed_data[k] = [] unless seed_data.key? k
    seed_data[k] += v
  end
end

# destroy DB
puts "Destroying Existing DB"
Tag.destroy_all
User.destroy_all # dependent destroys should wipe Glance, Connection, Checkin
raise RuntimeError, 'DB improperly purged' if Glance.any? || Connection.any? || Checkin.any?


# Tag
puts "Seeding Tags"
tags = {}
seed_data['tags'].each do |t_id|
  tags[t_id] = Tag.create!({value: t_id})
end
puts "  Added #{Tag.count} tags"

# User
puts "Seeding User"
users = {}
seed_data['users'].each do |u_def|
  u_id = u_def['_slug']
  users[u_id] = User.new(u_def.mslice)
  users[u_id].birthday = u_def['_birthday']&.to_yearless_date if u_def['_birthday']
  users[u_id].save!
  puts "  Added #{u_id}"
end

# Connection
puts "Seeding Connection, their Tag & Glance"
connections = {}
seed_data['connections'].each do |c_def|
  c_id = c_def['_slug']
  connections[c_id] = Connection.new(c_def.mslice)
  connections[c_id].user = users[c_def['_user_slug']]
  connections[c_id].birthday = c_def['_birthday']&.to_yearless_date if c_def['_birthday']
  connections[c_id].tags = c_def['_tags'].map { |t_id| tags[t_id] } if c_def['_tags']
  connections[c_id].glances = c_def['_glances'].map { |g_def| Glance.new(g_def) } if c_def['_glances']
  connections[c_id].save!
  puts "  Added #{c_id} (#{connections[c_id].tags.count} tags, #{connections[c_id].glances.count} glances)"
end

# Checkin
puts "Seeding Checkin"
seed_data['checkins'].each do |ci_def|
  ci = Checkin.new(ci_def.mslice)
  ci.user = users[ci_def['_usr_slug']]
  ci.connections = ci_def['_connection_slugs'].map { |c_id| connections[c_id] } if ci_def['_connection_slugs']
  ci.time = ci_def['_time'].to_timeshift
  ci.save!
  puts "  Added #{ci.description&.truncate(15)} | with #{ci_def['_connection_slugs']&.join(', ')}"
end

#===============================================================
# Special Tasks ! ! FRAGILE ! !

# Make Sylvain the 3rd pending user
usr = User.find_by(first_name: 'Gerard')
syl = Connection.search('Sylvain Pierre').first
third_pending = usr.connections.pending.order(created_at: :desc).limit(2).last
if syl&.is_a? Connection
  if third_pending&.is_a? Connection
    syl.update(created_at: third_pending.created_at - 0.001.second)
  end
  syl.update(live: nil)
else
  raise "Could not find Sylvain!!!!!"
end

puts "Finished seeding"
