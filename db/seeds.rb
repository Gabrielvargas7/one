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

require 'open-uri'
require 'json'

require_relative 'seeds/seeds_themes'
require_relative 'seeds/seeds_themes_images'

require_relative 'seeds/seeds_item'
require_relative 'seeds/seeds_item_images'

require_relative 'seeds/seeds_bundle'
require_relative 'seeds/seeds_bundle_images'

require_relative 'seeds/seeds_bookmarks'
require_relative 'seeds/seeds_bookmarks_images'

require_relative 'seeds/seeds_reset_sequence'
require_relative 'seeds/seeds_notification'

require_relative 'seeds/seeds_update_user'




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

  #Items
#ws = session.spreadsheet_by_key("0ApGllgrhiMhwdDNCZE1JejZKekJQaW5UbWxnaHl6ZkE").worksheets[4]
#SeedItemsModule.InsertItems(ws)
#
#
######Themes
#ws = session.spreadsheet_by_key("0ApGllgrhiMhwdDNCZE1JejZKekJQaW5UbWxnaHl6ZkE").worksheets[2]
#SeedThemesModule.InsertThemes(ws)
#
########Bundle table
#ws = session.spreadsheet_by_key("0ApGllgrhiMhwdDNCZE1JejZKekJQaW5UbWxnaHl6ZkE").worksheets[1]
#SeedBundleModule.InsertBundles(ws)
##
#########Item_Design table
#ws = session.spreadsheet_by_key("0ApGllgrhiMhwdDNCZE1JejZKekJQaW5UbWxnaHl6ZkE").worksheets[3]
#SeedItemsModule.InsertItemsDesign(ws)
##
###
###########Bookmark categories table
#ws = session.spreadsheet_by_key("0ApGllgrhiMhwdDNCZE1JejZKekJQaW5UbWxnaHl6ZkE").worksheets[6]
#SeedBookmarkModule.InsertBookmarkCategory(ws)
#
#######Bookmark table
#ws = session.spreadsheet_by_key("0ApGllgrhiMhwdDNCZE1JejZKekJQaW5UbWxnaHl6ZkE").worksheets[5]
#SeedBookmarkModule.InsertBookmarks(ws)
#
#
########Bundle_bookmarks table
#ws = session.spreadsheet_by_key("0ApGllgrhiMhwdDNCZE1JejZKekJQaW5UbWxnaHl6ZkE").worksheets[0]
#  SeedBundleModule.InsertBundlesBookmarks(ws)
#
########Notification table
#ws = session.spreadsheet_by_key("0ApGllgrhiMhwdDNCZE1JejZKekJQaW5UbWxnaHl6ZkE").worksheets[7]
#SeedNotificationModule.InsertNotification(ws)
#
#
##
#SeedResetSequence.ResetSequenceOnPostgreDb


#Don't use it
## this is only one time to transfer the images to the project from my local computer to the seeds/images folder
#Don't user any more
#   SeedThemeImagesModule.transfer_themes_image
#   SeedBundleImagesModule.transfer_bundles_image
#   SeedItemsImagesModule.transfer_items_image_main
#   SeedItemsImagesModule.transfer_items_image_300
#   SeedBookmarksImageModule.transfer_bookmarks_image


#p Dir.glob("db/seeds/images/themes/*")


#########################
# transfer user from mysql
#########################

@users = JSON.parse(open("http://localhost:8084/EtlRoom/json/all").read)
#p @users

p "#########################"
p "tranfer users "
p "#########################"

@users.each do |user|
  #Rails.logger.info user.inspect
  p user["id"]
  p user["email"]
  p user["firstname"]
  p user["lastname"]


  if User.exists?(email:user["email"] )
    p "user already on db "+ user["email"]
  else
    ActiveRecord::Base.transaction do
      begin
        p "new user add it db "+ user["email"]
        User.create!(email: user["email"], password: "onetwo1234")
      rescue
        p "Error on email"+ user["email"]
        raise ActiveRecord::Rollback
      end
    end

    if User.exists?(email:user["email"] )
      @user_id = User.find_by_email(user["email"])
      if UsersProfile.exists?(user_id:@user_id.id)
         @user_profile = UsersProfile.find_by_user_id(@user_id.id)
         @user_profile.update_attributes(firstname:user["firstname"],lastname:user["lastname"])
         ActiveRecord::Base.transaction do
           begin
             p "Updating firstname lastname "+user["firstname"]
             @user_profile.update_attributes(firstname:user["firstname"],lastname:user["lastname"])
           rescue
             p "Error on Updateting firstname "+user["firstname"]

             raise ActiveRecord::Rollback
           end
         end



      end
    end


  end

end
#########################
# get the friends
#########################
p "#########################"
p "Geting the friends "
p "#########################"

#@users = User.all
@users.each do |user|
  #Rails.logger.info user.inspect
  p user["id"]
  p user["email"]
  #p user["firstname"]
  friend_url = "http://localhost:8084/EtlRoom/json/friends/"+user["id"].to_s
  p friend_url

  @friends = JSON.parse(open(friend_url).read)

  @friends.each do |friend|
    if User.exists?(email:friend["email"] ) and User.exists?(email:user["email"] )
        p "user already on db "+ friend["email"]

        @user_friend = User.find_by_email(friend["email"])
        @user_friend2 = User.find_by_email(user["email"])

        #p "friend one "+@user_friend.id.to_s+" "+@user_friend.email.to_s
        #p "friend two "+@user_friend2.id.to_s+" "+@user_friend.email2.to_s
        if Friend.exists?(user_id:@user_friend.id,user_id_friend:@user_friend2.id)

          p "friend alredy on db "+ @user_friend2.id.to_s+" "+@user_friend2.email.to_s
          p "friend alredy on db "+ @user_friend.id.to_s+" "+@user_friend.email.to_s

        else
          p "friend add it on db "+ @user_friend2.id.to_s+" "+@user_friend2.email.to_s
          p "friend add it on db "+ @user_friend.id.to_s+" "+@user_friend.email.to_s


          Friend.create(user_id:@user_friend.id,user_id_friend:@user_friend2.id)
          Friend.create(user_id:@user_friend2.id.to_s,user_id_friend:@user_friend.id)
        end

    else
      p "one of this don't exist on db "+ friend["email"]
      p user["email"]

    end
  end
end

########################
# add old user the new item
########################

#item_id = 25
#location_id = 25
#SeedUpdateUserModule.InsertNewItemsTooldUser(item_id,location_id)


########################
# clean user_bookmarks and add the preset bookmark
########################

#@users = User.all
#UsersBookmark.delete_all
#
#@items = Item.all
#@bundle_bookmarks = BundlesBookmark.all
#
#  @users.each do |user|
#    puts user.id
#    @items.each do |item|
#      position = 1
#      if BundlesBookmark.
#          joins(:bookmark).
#          joins('inner join bookmarks_categories ON bookmarks_categories.id = bookmarks.bookmarks_category_id').
#          where('bookmarks_categories.item_id = ?',item.id).exists?
#
#
#        @bundle_bookmarks = BundlesBookmark.
#            joins(:bookmark).
#            joins('inner join bookmarks_categories ON bookmarks_categories.id = bookmarks.bookmarks_category_id').
#            where('bookmarks_categories.item_id = ?',item.id)
#
#
#        @bundle_bookmarks.each do |bundle_bookmark|
#          UsersBookmark.create!(user_id:user.id,bookmark_id:bundle_bookmark.bookmark_id,position:position)
#          position = position+1
#        end
#      end
#    end
#
#  end



