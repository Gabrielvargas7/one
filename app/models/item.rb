class Item < ActiveRecord::Base
  attr_accessible :clickable, :folder_name, :height, :name, :width, :x, :y, :z
end
