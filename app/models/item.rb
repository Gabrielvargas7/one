class Item < ActiveRecord::Base
  attr_accessible :bundle_id, :description, :item_location_id, :name
end
