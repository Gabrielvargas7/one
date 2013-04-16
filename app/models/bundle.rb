class Bundle < ActiveRecord::Base
  attr_accessible :description, :image_name, :name, :theme_id

  mount_uploader :image_name, BundlesImageUploader
end
