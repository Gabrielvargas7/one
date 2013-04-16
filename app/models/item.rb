class Item < ActiveRecord::Base
  attr_accessible :clickable, :folder_name, :height, :name, :width, :x, :y, :z

  has_many :items_designs
  has_many :bookmarks_categories
  has_many :bookmarks
  has_many :bundles_bookmarks

end
