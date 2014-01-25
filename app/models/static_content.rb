class StaticContent < ActiveRecord::Base
  attr_accessible :description, :image_name, :name

  mount_uploader :image_name, StaticContentsImageNameUploader

  validates :name,
            presence: true,
            uniqueness:{ case_sensitive: false }


end
