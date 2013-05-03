class UsersGallery < ActiveRecord::Base
  attr_accessible :image_name, :default_image, :user_id

  mount_uploader :image_name, UsersGalleriesImageUploader

  belongs_to :user

end
