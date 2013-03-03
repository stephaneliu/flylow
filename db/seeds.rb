# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) are set in the file config/application.yml.
# See http://railsapps.github.com/rails-environment-variables.html
puts 'ROLES'

if Rails.env == "production"
  %w(admin, user, VIP).each do |role|
    Role.find_or_create_by_name({ :name => role }, :without_protection => true)
  end
else
  YAML.load(ENV['ROLES']).each do |role|
    Role.find_or_create_by_name({ :name => role }, :without_protection => true)
    puts 'role: ' << role
  end
  puts 'DEFAULT USERS'
  user = User.find_or_create_by_email :name => ENV['ADMIN_NAME'].dup, :email => ENV['ADMIN_EMAIL'].dup, :password => ENV['ADMIN_PASSWORD'].dup, :password_confirmation => ENV['ADMIN_PASSWORD'].dup
  puts 'user: ' << user.name
  user.add_role :admin
end

{ "Oahu" => ["HNL", "Domestic"], 
  "Hawaii Island - Hilo, HI" => ["ITO", "Domestic"],
  "Hawaiia Island - Kona, HI" => ["KOA", "Domestic"],
  "Kauai - Lihue, HI" => ["LIH", "Domestic"],
  "Maui - Kahului, HI" => ["OGG", "Domestic"],
  "Maui - Kapalua, HI" => ["JHM", "Domestic"],
  "Boston, MA" => ["BOS", "Domestic"],
  "Buffalo, NY" => ["BUF", "Domestic"],
  "Burlington, VT" => ["BTV", "Domestic"],
  "Charlotte, NC" => ["CLT", "Domestic"],
  "Chicago, IL" => ["ORD", "Domestic"],
  "Dallas/Ft Worth, TX" => ["DFW", "Domestic"],
  "Fort Lauderdale, FL" => ["FLL", "Domestic"],
  "Fresno, CA" => ["FAT", "Domestic"],
  "Las Vegas, NV" => ["LAS", "Domestic"],
  "Los Angeles, CA" => ["LAX", "Domestic"],
  "Monterey, CA" => ["MRY", "Domestic"],
  "New York, NY" => ["JFK", "Domestic"],
  "Newark, NJ" => ["EWR", "Domestic"],
  "Oakland, CA" => ["OAK", "Domestic"],
  "Orlando, FL" => ["MCO", "Domestic"],
  "Philadelphia, PA" => ["PHL", "Domestic"],
  "Phoenix, AZ" => ["PHX", "Domestic"],
  "Portland, ME" => ["PWM", "Domestic"],
  "Portland, OR" => ["PDX", "Domestic"],
  "Raleigh/Durham, NC" => ["RDU", "Domestic"],
  "Rochester, NY" => ["ROC", "Domestic"],
  "Sacramento, CA" => ["SMF", "Domestic"],
  "San Diego, CA" => ["SAN", "Domestic"],
  "San Francisco, CA" => ["SFO", "Domestic"],
  "San Jose, CA" => ["SJC", "Domestic"],
  "Santa Barbara, CA" => ["SBA", "Domestic"],
  "Seattle, WA" => ["SEA", "Domestic"],
  "Syracuse, NY" => ["SYR", "Domestic"],
  "Tampa, FL" => ["TPA", "Domestic"],
  "Washington-Dulles, DC" => ["IAD", "Domestic"],
  "West Palm Beach, FL" => ["PBI", "Domestic"],
  "Auckland, New Zealand" => ["AKL", "International"],
  "Bangkok, Thailand" => ["BKK", "International"],
  "Brisbane, Australia" => ["BNE", "International"],
  "Busan, South Korea" => ["PUS", "International"],
  "Fukuoka, Japan" => ["FUK", "International"],
  "Hiroshima, Japan" => ["HIJ", "International"],
  "Kagoshima, Japan" => ["KOJ", "International"],
  "Manila, Philippines" => ["MNL", "International"],
  "Oita, Japan" => ["OIT", "International"],
  "Okinawa, Japan" => ["OKA", "International"],
  "Osaka Itami, Japan" => ["ITM", "International"],
  "Osaka-Kansai, Japan" => ["KIX", "International"],
  "Pago Pago, Samoa" => ["PPG", "International"],
  "Papeete, Tahiti" => ["PPT", "International"],
  "Sapporo/Chitose, Japan" => ["CTS", "International"],
  "Seoul-Incheon, South Korea" => ["ICN", "International"],
  "Sydney, Australia" => ["SYD", "International"],
  "Taipei, Taiwan" => ["TPE", "International"],
  "Tokyo-Haneda, Japan" => ["HND", "International"]}.each do |city, code_region|
  code, region = code_region
  City.find_or_create_by_name(name: city, airport_code: code, region: region)
end

# Favorites
["HNL", "KOA", "LIH", "OGG", "JHM", "BOS", "ORD", "FLL", "LAS", "LAX", "MRY", "JFK", "EWR", "OAK", "PDX", "SAN", "SFO", "SJC",
  "SEA"].each do |code|
  City.find_by_airport_code(code).update_attribute(:favorite, true)
  end

["ITO", "KOA", "LIH", "JHM", "BOS", "ORD", "SAN", "FLL", "MRY", "EWR", "OAK", "SJC"].each do |code|
  City.find_by_airport_code(code).update_attribute(:favorite, false)
end
