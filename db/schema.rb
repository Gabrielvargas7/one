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

ActiveRecord::Schema.define(:version => 20130503171040) do

  create_table "bookmarks", :force => true do |t|
    t.integer  "bookmarks_category_id"
    t.integer  "item_id"
    t.text     "bookmark_url"
    t.string   "title"
    t.string   "i_frame"
    t.string   "image_name"
    t.string   "image_name_desc"
    t.text     "description"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "bookmarks", ["bookmark_url"], :name => "index_bookmarks_on_bookmark_url"
  add_index "bookmarks", ["bookmarks_category_id"], :name => "index_bookmarks_on_bookmarks_category_id"
  add_index "bookmarks", ["id"], :name => "index_bookmarks_on_id"
  add_index "bookmarks", ["item_id"], :name => "index_bookmarks_on_item_id"
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
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "bundles", ["id"], :name => "index_bundles_on_id"
  add_index "bundles", ["name"], :name => "index_bundles_on_name"
  add_index "bundles", ["theme_id"], :name => "index_bundles_on_theme_id"

  create_table "bundles_bookmarks", :force => true do |t|
    t.integer  "item_id"
    t.integer  "bookmark_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "bundles_bookmarks", ["bookmark_id"], :name => "index_bundles_bookmarks_on_bookmark_id"
  add_index "bundles_bookmarks", ["id"], :name => "index_bundles_bookmarks_on_id"
  add_index "bundles_bookmarks", ["item_id"], :name => "index_bundles_bookmarks_on_item_id"

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

  create_table "friends", :force => true do |t|
    t.integer  "user_id"
    t.integer  "user_id_friend"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "items", :force => true do |t|
    t.string   "name"
    t.decimal  "x"
    t.decimal  "y"
    t.integer  "z"
    t.integer  "width"
    t.integer  "height"
    t.string   "clickable"
    t.string   "folder_name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
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
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "items_designs", ["bundle_id"], :name => "index_items_designs_on_bundle_id"
  add_index "items_designs", ["id"], :name => "index_items_designs_on_id"
  add_index "items_designs", ["item_id"], :name => "index_items_designs_on_item_id"
  add_index "items_designs", ["name"], :name => "index_items_designs_on_name"

  create_table "notifications", :force => true do |t|
    t.string   "name"
    t.string   "image_name"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "themes", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "image_name"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "image_name_selection"
  end

  add_index "themes", ["id"], :name => "index_themes_on_id"
  add_index "themes", ["name"], :name => "index_themes_on_name"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
    t.string   "username"
    t.string   "image_name"
  end

  add_index "users", ["admin"], :name => "index_users_on_admin"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["id"], :name => "index_users_on_id"
  add_index "users", ["name"], :name => "index_users_on_name"
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

  create_table "users_galleries", :force => true do |t|
    t.integer  "user_id"
    t.string   "image_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users_items_designs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "items_design_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "hide"
  end

  add_index "users_items_designs", ["id"], :name => "index_users_items_designs_on_id"
  add_index "users_items_designs", ["items_design_id"], :name => "index_users_items_designs_on_items_design_id"
  add_index "users_items_designs", ["user_id"], :name => "index_users_items_designs_on_user_id"

  create_table "users_notifications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "notification_id"
    t.string   "notified",        :default => "y", :null => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "users_themes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "theme_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "users_themes", ["id"], :name => "index_users_themes_on_id"
  add_index "users_themes", ["theme_id"], :name => "index_users_themes_on_theme_id"
  add_index "users_themes", ["user_id"], :name => "index_users_themes_on_user_id"

end
