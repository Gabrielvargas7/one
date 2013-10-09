# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131008210804) do

  create_table "bookmarks", :force => true do |t|
    t.integer  "bookmarks_category_id"
    t.text     "bookmark_url"
    t.string   "title"
    t.string   "i_frame",               :default => "y"
    t.string   "image_name"
    t.string   "image_name_desc"
    t.text     "description"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "approval",              :default => "y"
    t.integer  "user_bookmark",         :default => 0
    t.integer  "like",                  :default => 0
  end

  add_index "bookmarks", ["bookmark_url"], :name => "index_bookmarks_on_bookmark_url"
  add_index "bookmarks", ["bookmarks_category_id"], :name => "index_bookmarks_on_bookmarks_category_id"
  add_index "bookmarks", ["id"], :name => "index_bookmarks_on_id"
  add_index "bookmarks", ["title"], :name => "index_bookmarks_on_title"

  create_table "bookmarks_categories", :force => true do |t|
    t.string   "name"
    t.integer  "item_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "bookmarks_categories", ["id"], :name => "index_bookmarks_categories_on_id"
  add_index "bookmarks_categories", ["item_id"], :name => "index_bookmarks_categories_on_item_id"
  add_index "bookmarks_categories", ["name"], :name => "index_bookmarks_categories_on_name"

  create_table "bundles", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "theme_id"
    t.string   "image_name"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "image_name_set"
    t.integer  "section_id"
    t.string   "active",         :default => "n"
    t.string   "category"
    t.string   "style"
    t.string   "brand"
    t.string   "location"
    t.string   "color"
    t.string   "make"
    t.string   "special_name"
    t.integer  "like",           :default => 0
  end

  add_index "bundles", ["brand"], :name => "index_bundles_on_brand"
  add_index "bundles", ["category"], :name => "index_bundles_on_category"
  add_index "bundles", ["color"], :name => "index_bundles_on_color"
  add_index "bundles", ["description"], :name => "index_bundles_on_description"
  add_index "bundles", ["id"], :name => "index_bundles_on_id"
  add_index "bundles", ["location"], :name => "index_bundles_on_location"
  add_index "bundles", ["make"], :name => "index_bundles_on_make"
  add_index "bundles", ["name"], :name => "index_bundles_on_name"
  add_index "bundles", ["special_name"], :name => "index_bundles_on_special_name"
  add_index "bundles", ["style"], :name => "index_bundles_on_style"
  add_index "bundles", ["theme_id"], :name => "index_bundles_on_theme_id"

  create_table "bundles_bookmarks", :force => true do |t|
    t.integer  "bookmark_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "bundles_bookmarks", ["bookmark_id"], :name => "index_bundles_bookmarks_on_bookmark_id"
  add_index "bundles_bookmarks", ["id"], :name => "index_bundles_bookmarks_on_id"

  create_table "bundles_items_designs", :force => true do |t|
    t.integer  "items_design_id"
    t.integer  "location_id"
    t.integer  "bundle_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "feedbacks", :force => true do |t|
    t.text     "description"
    t.integer  "user_id"
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "friend_requests", :force => true do |t|
    t.integer  "user_id"
    t.integer  "user_id_requested"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "friend_requests", ["user_id"], :name => "index_friend_requests_on_user_id"
  add_index "friend_requests", ["user_id_requested"], :name => "index_friend_requests_on_user_id_requested"

  create_table "friends", :force => true do |t|
    t.integer  "user_id"
    t.integer  "user_id_friend"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "friends", ["user_id"], :name => "index_friends_on_user_id"
  add_index "friends", ["user_id_friend"], :name => "index_friends_on_user_id_friend"

  create_table "items", :force => true do |t|
    t.string   "name"
    t.string   "clickable",      :default => "yes"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "image_name"
    t.integer  "priority_order", :default => 0
  end

  add_index "items", ["id"], :name => "index_items_on_id"
  add_index "items", ["name"], :name => "index_items_on_name"

  create_table "items_designs", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "item_id"
    t.integer  "bundle_id"
    t.string   "image_name"
    t.string   "image_name_hover"
    t.string   "image_name_selection"
    t.datetime "created_at",                                                          :null => false
    t.datetime "updated_at",                                                          :null => false
    t.string   "category"
    t.string   "style"
    t.string   "brand"
    t.string   "color"
    t.string   "make"
    t.string   "special_name"
    t.integer  "like",                                               :default => 0
    t.decimal  "price",                :precision => 8, :scale => 2, :default => 0.0
    t.string   "product_url"
  end

  add_index "items_designs", ["brand"], :name => "index_items_designs_on_brand"
  add_index "items_designs", ["bundle_id"], :name => "index_items_designs_on_bundle_id"
  add_index "items_designs", ["category"], :name => "index_items_designs_on_category"
  add_index "items_designs", ["color"], :name => "index_items_designs_on_color"
  add_index "items_designs", ["description"], :name => "index_items_designs_on_description"
  add_index "items_designs", ["id"], :name => "index_items_designs_on_id"
  add_index "items_designs", ["item_id"], :name => "index_items_designs_on_item_id"
  add_index "items_designs", ["make"], :name => "index_items_designs_on_make"
  add_index "items_designs", ["name"], :name => "index_items_designs_on_name"
  add_index "items_designs", ["special_name"], :name => "index_items_designs_on_special_name"
  add_index "items_designs", ["style"], :name => "index_items_designs_on_style"

  create_table "items_locations", :force => true do |t|
    t.integer  "item_id"
    t.integer  "location_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "items_locations", ["item_id"], :name => "index_items_locations_on_item_id"
  add_index "items_locations", ["location_id"], :name => "index_items_locations_on_location_id"

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.decimal  "x",           :precision => 8, :scale => 1
    t.decimal  "y",           :precision => 8, :scale => 1
    t.integer  "z"
    t.integer  "width"
    t.integer  "height"
    t.integer  "section_id"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "locations", ["description"], :name => "index_locations_on_description"
  add_index "locations", ["name"], :name => "index_locations_on_name"

  create_table "notifications", :force => true do |t|
    t.string   "name"
    t.string   "image_name"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "description"
    t.integer  "position"
  end

  add_index "notifications", ["description"], :name => "index_notifications_on_description"
  add_index "notifications", ["name"], :name => "index_notifications_on_name"
  add_index "notifications", ["position"], :name => "index_notifications_on_position"
  add_index "notifications", ["user_id"], :name => "index_notifications_on_user_id"

  create_table "sections", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "sections", ["description"], :name => "index_sections_on_description"
  add_index "sections", ["name"], :name => "index_sections_on_name"

  create_table "themes", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "image_name"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "image_name_selection"
    t.string   "category"
    t.string   "style"
    t.string   "brand"
    t.string   "location"
    t.string   "color"
    t.string   "make"
    t.string   "special_name"
    t.integer  "like",                 :default => 0
  end

  add_index "themes", ["brand"], :name => "index_themes_on_brand"
  add_index "themes", ["category"], :name => "index_themes_on_category"
  add_index "themes", ["color"], :name => "index_themes_on_color"
  add_index "themes", ["description"], :name => "index_themes_on_description"
  add_index "themes", ["id"], :name => "index_themes_on_id"
  add_index "themes", ["location"], :name => "index_themes_on_location"
  add_index "themes", ["make"], :name => "index_themes_on_make"
  add_index "themes", ["name"], :name => "index_themes_on_name"
  add_index "themes", ["special_name"], :name => "index_themes_on_special_name"
  add_index "themes", ["style"], :name => "index_themes_on_style"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",                  :default => false
    t.string   "username"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["admin"], :name => "index_users_on_admin"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["id"], :name => "index_users_on_id"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"
  add_index "users", ["username"], :name => "index_users_on_username"

  create_table "users_bookmarks", :force => true do |t|
    t.integer  "user_id"
    t.integer  "bookmark_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "position"
  end

  add_index "users_bookmarks", ["bookmark_id"], :name => "index_users_bookmarks_on_bookmark_id"
  add_index "users_bookmarks", ["id"], :name => "index_users_bookmarks_on_id"
  add_index "users_bookmarks", ["position"], :name => "index_users_bookmarks_on_position"
  add_index "users_bookmarks", ["user_id"], :name => "index_users_bookmarks_on_user_id"

  create_table "users_items_designs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "items_design_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "hide"
    t.integer  "location_id",     :default => 0
  end

  add_index "users_items_designs", ["id"], :name => "index_users_items_designs_on_id"
  add_index "users_items_designs", ["items_design_id"], :name => "index_users_items_designs_on_items_design_id"
  add_index "users_items_designs", ["user_id"], :name => "index_users_items_designs_on_user_id"

  create_table "users_notifications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "notification_id", :default => 0
    t.string   "notified",        :default => "y", :null => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "users_photos", :force => true do |t|
    t.integer  "user_id"
    t.string   "description"
    t.string   "image_name"
    t.string   "profile_image", :default => "n"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "users_photos", ["description"], :name => "index_users_photos_on_description"
  add_index "users_photos", ["profile_image"], :name => "index_users_photos_on_profile_image"
  add_index "users_photos", ["user_id"], :name => "index_users_photos_on_user_id"

  create_table "users_profiles", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "gender"
    t.string   "description"
    t.string   "city"
    t.string   "country"
    t.date     "birthday"
    t.integer  "user_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "friends_number", :default => 0
  end

  add_index "users_profiles", ["birthday"], :name => "index_users_profiles_on_birthday"
  add_index "users_profiles", ["city"], :name => "index_users_profiles_on_city"
  add_index "users_profiles", ["country"], :name => "index_users_profiles_on_country"
  add_index "users_profiles", ["description"], :name => "index_users_profiles_on_description"
  add_index "users_profiles", ["firstname"], :name => "index_users_profiles_on_firstname"
  add_index "users_profiles", ["gender"], :name => "index_users_profiles_on_gender"
  add_index "users_profiles", ["lastname"], :name => "index_users_profiles_on_lastname"
  add_index "users_profiles", ["user_id"], :name => "index_users_profiles_on_user_id", :unique => true

  create_table "users_themes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "theme_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "section_id"
  end

  add_index "users_themes", ["id"], :name => "index_users_themes_on_id"
  add_index "users_themes", ["theme_id"], :name => "index_users_themes_on_theme_id"
  add_index "users_themes", ["user_id"], :name => "index_users_themes_on_user_id"

end
