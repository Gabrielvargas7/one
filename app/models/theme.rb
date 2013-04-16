class Theme < ActiveRecord::Base
  attr_accessible :description, :image_name, :name ,:image_popthumb

  mount_uploader :image_name, ThemesImageUploader

  mount_uploader :image_popthumb, ThemesImagePopthumbUploader
end
