class Theme < ActiveRecord::Base
  attr_accessible :name, :description, :image_name,:image_name_selection

  mount_uploader :image_name, ThemesImageUploader
  mount_uploader :image_name_selection, ThemesImageSelectionUploader

  has_one :bundle

  has_many :users_themes


  # combine id and name to show in the (collection element) on the front-end
  def id_and_theme
    "#{id}. #{name}"
  end


end
