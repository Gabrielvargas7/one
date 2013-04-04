# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# read file themes https://docs.google.com/spreadsheet/ccc?key=0ApGllgrhiMhwdFNGOUpaWXpnMFYtNnAyUTlfM0FSYlE&output=txt


puts "Loading Themes to the database"
Theme.delete_all
    require_relative 'seeds/seeds_themes'

puts "Loading ItemLocations to the database"
ItemLocation.delete_all
    require_relative 'seeds/seeds_item_locations'

puts "Loading Bundles to the database"
ItemLocation.delete_all
  require_relative 'seeds/seeds_bundles1'

puts "Loading Items to the database"
ItemLocation.delete_all
require_relative 'seeds/seeds_items1'


