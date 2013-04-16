class Bundle < ActiveRecord::Base
  attr_accessible :description, :image_name, :name, :theme_id

  mount_uploader :image_name, BundlesImageUploader

  belongs_to :theme
  has_many :items_designs
end
