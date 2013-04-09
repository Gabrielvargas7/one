# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require "rubygems"
require "google_drive"

require_relative 'seeds/seeds_themes'
require_relative 'seeds/seeds_item'
require_relative 'seeds/seeds_bundle'
require_relative 'seeds/seeds_bookmarks'

#module ImageHelper
#  def self.fix_image_name image_name
#    image_name.downcase!
#    image_name.strip!
#    namesplit = image_name.split(' ').join('-')
#  end
#end

# Logs in.
# You can also use OAuth. See document of
# GoogleDrive.login_with_oauth for details.
session = GoogleDrive.login("rooms.team@mywebroom.com", "rooms123")

# First worksheet of
#
# fix the image name
#def fix_image_name image_name
#  image_name.downcase!
#  image_name.strip!
#  namesplit = image_name.split(' ').join('-')
#end


#Items
#https://docs.google.com/a/mywebroom.com/spreadsheet/ccc?key=0ApGllgrhiMhwdE42em9id0VNRVBTemxoLXptcjVEb2c&usp=sharing
  ws = session.spreadsheet_by_key("0ApGllgrhiMhwdE42em9id0VNRVBTemxoLXptcjVEb2c").worksheets[0]
  SeedItemsModule.InsertItems(ws)
  Test

###Themes
###https://docs.google.com/a/mywebroom.com/spreadsheet/ccc?key=0ApGllgrhiMhwdFNGOUpaWXpnMFYtNnAyUTlfM0FSYlE&usp=sharing
# ws = session.spreadsheet_by_key("0ApGllgrhiMhwdFNGOUpaWXpnMFYtNnAyUTlfM0FSYlE").worksheets[0]
# SeedThemesModule.InsertThemes(ws)
##
###Bundle table
###https://docs.google.com/a/mywebroom.com/spreadsheet/ccc?key=0ApGllgrhiMhwdEEtT2wxbkRrcXJnMTlKa0dwaGJwN1E&usp=sharing
#  ws = session.spreadsheet_by_key("0ApGllgrhiMhwdEEtT2wxbkRrcXJnMTlKa0dwaGJwN1E").worksheets[0]
#  SeedBundleModule.InsertBundles(ws)
##
###Item_Design table
###https://docs.google.com/a/mywebroom.com/spreadsheet/ccc?key=0ApGllgrhiMhwdHZCMGQzeTJNYWtsbF93Vzk3U1JpSFE&usp=sharing
#  ws = session.spreadsheet_by_key("0ApGllgrhiMhwdHZCMGQzeTJNYWtsbF93Vzk3U1JpSFE").worksheets[0]
#  SeedItemsModule.InsertItemsDesign(ws)
##
#
###Bookmark category table
###https://docs.google.com/a/mywebroom.com/spreadsheet/ccc?key=0ApGllgrhiMhwdGpDcEczcktkZmZLcWx2RXF6NFVweXc&usp=sharing
#    ws = session.spreadsheet_by_key("0ApGllgrhiMhwdGpDcEczcktkZmZLcWx2RXF6NFVweXc").worksheets[0]
#    SeedBookmarkModule.InsertBookmarkCategory(ws)
#



