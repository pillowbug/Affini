require "json"
require "rest-client"
require "pry-byebug"

UNIQ_SLUGS = ['usr']
UNIQ_PICS = ['https://randomuser.me/api/portraits/women/62.jpg'] # known duplicates

NATIONALITIES=%w[AU BR CA CH DE DK ES FI FR GB NO NL NZ US].join(',')

def generate_connections(usr_slug, seed, n_user_max, args = {live: true} )
  res = []

  data = JSON.parse(RestClient.get("https://randomuser.me/api/?seed=#{seed}&nat=#{NATIONALITIES}&results=#{n_user_max}"))
  data['results'].each do |fc|
    slug = fc['login']['username']
    pic = fc['picture']['large']
    next if UNIQ_SLUGS.include?(slug) || UNIQ_PICS.include?(pic)

    UNIQ_SLUGS << slug
    UNIQ_PICS << pic
    first_name = fc['name']['first']
    last_name = fc['name']['last']
    birthday = Date.parse(fc['dob']['date']).strftime('%-d %B')
    email = fc['email']
    phone = fc['phone']
    # tag based on parity of last_name letter count
    tag = first_name.length.even? ? 'work' : 'friend'
    live = args[:live] ? fc['registered']['date'] : nil

    res << <<-eos
  - _slug: #{slug}
    _user_slug: #{usr_slug}
    first_name: #{first_name}
    last_name: #{last_name}
    _birthday: #{birthday}
    email: #{email}
    phone_number: #{phone}
    # remote_photo_url: #{pic}
    live: #{live}
    _tags:
      - #{tag}
eos
  end
  res
end


connections_live = generate_connections('usr', 'affini', 10, live: true)
connections_pending = generate_connections('usr', 'affini-backlog', 30, live: false)

# puts live.length
# puts backlog.length

# puts UNIQ_SLUGS.count
# puts UNIQ_PICS.count

puts "connections:"
puts connections_live
puts connections_pending
