class Theme < ActiveRecord::Base
  attr_accessible :description, :image_name, :name ,:image_name_selection

  mount_uploader :image_name, ThemesImageUploader
  mount_uploader :image_name_selection, ThemesImageSelectionUploader

  has_one :bundle


end
