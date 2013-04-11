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

ActiveRecord::Schema.define(:version => 20130410120520) do

  create_table "advertisements", :force => true do |t|
    t.string   "image_name"
    t.string   "description"
    t.integer  "bookmark_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "bookmarks", :force => true do |t|
    t.integer  "bookmarks_category_id"
    t.string   "bookmark_url"
    t.string   "title"
    t.string   "i_frame"
    t.string   "image_name"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "image_name_desc"
    t.text     "description"
    t.integer  "item_id"
  end

  create_table "bookmarks_categories", :force => true do |t|
    t.integer  "item_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "bundles", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "theme_id"
    t.string   "image_name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "bundles_bookmarks", :force => true do |t|
    t.integer  "item_id"
    t.integer  "bookmark_id", :limit => 255
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "items", :force => true do |t|
    t.string   "name"
    t.decimal  "x"
    t.decimal  "y"
    t.integer  "z"
    t.integer  "width"
    t.integer  "height"
    t.string   "clickable"
    t.string   "image_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "items_designs", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "item_id"
    t.integer  "bundle_id"
    t.string   "image_name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "rooms", :force => true do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.integer  "theme_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "themes", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "image_name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
