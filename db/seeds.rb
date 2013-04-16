# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require "rubygems"
require "google_drive"
require "fileutils"

require_relative 'seeds/seeds_themes'
require_relative 'seeds/seeds_themes_images'

require_relative 'seeds/seeds_item'
require_relative 'seeds/seeds_item_images'

require_relative 'seeds/seeds_bundle'
require_relative 'seeds/seeds_bundle_images'

require_relative 'seeds/seeds_bookmarks'
require_relative 'seeds/seeds_bookmarks_images'


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

#DB data
#https://docs.google.com/a/mywebroom.com/spreadsheet/ccc?key=0ApGllgrhiMhwdDNCZE1JejZKekJQaW5UbWxnaHl6ZkE&usp=sharing

  #####Items
ws = session.spreadsheet_by_key("0ApGllgrhiMhwdDNCZE1JejZKekJQaW5UbWxnaHl6ZkE").worksheets[4]
SeedItemsModule.InsertItems(ws)
#
#
########Themes
ws = session.spreadsheet_by_key("0ApGllgrhiMhwdDNCZE1JejZKekJQaW5UbWxnaHl6ZkE").worksheets[2]
SeedThemesModule.InsertThemes(ws)
#
########Bundle table
ws = session.spreadsheet_by_key("0ApGllgrhiMhwdDNCZE1JejZKekJQaW5UbWxnaHl6ZkE").worksheets[1]
SeedBundleModule.InsertBundles(ws)
#
########Item_Design table
ws = session.spreadsheet_by_key("0ApGllgrhiMhwdDNCZE1JejZKekJQaW5UbWxnaHl6ZkE").worksheets[3]
SeedItemsModule.InsertItemsDesign(ws)
#
##
##########Bookmark categories table
ws = session.spreadsheet_by_key("0ApGllgrhiMhwdDNCZE1JejZKekJQaW5UbWxnaHl6ZkE").worksheets[6]
SeedBookmarkModule.InsertBookmarkCategory(ws)
#
#######Bookmark table
ws = session.spreadsheet_by_key("0ApGllgrhiMhwdDNCZE1JejZKekJQaW5UbWxnaHl6ZkE").worksheets[5]
SeedBookmarkModule.InsertBookmarks(ws)
#
#
#######Bundle_bookmarks table
ws = session.spreadsheet_by_key("0ApGllgrhiMhwdDNCZE1JejZKekJQaW5UbWxnaHl6ZkE").worksheets[0]
  SeedBundleModule.InsertBundlesBookmarks(ws)
##
##



## this is only one time to transfer the images
#   SeedThemeImagesModule.transfer_themes_image
   #SeedBundleImagesModule.transfer_bundles_image
   #SeedItemsImagesModule.transfer_items_image_main
   #SeedItemsImagesModule.transfer_items_image_300
   #SeedBookmarksImageModule.transfer_bookmarks_image


#p Dir.glob("db/seeds/images/themes/*")



