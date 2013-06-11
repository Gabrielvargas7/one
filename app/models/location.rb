class Location < ActiveRecord::Base
  attr_accessible :description, :height, :name, :section_id, :width, :x, :y, :z

end
