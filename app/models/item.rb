class Item < ActiveRecord::Base
  attr_accessible :clickable, :height, :image_name, :name, :width, :x, :y, :z
end
