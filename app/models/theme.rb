# == Schema Information
#
# Table name: themes
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  description          :text
#  image_name           :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  image_name_selection :string(255)
#

class Theme < ActiveRecord::Base
  attr_accessible :name, :description, :image_name,:image_name_selection, :image_name_cache,:image_name_selection_cache

  validates :name,
             presence:true

  mount_uploader :image_name, ThemesImageUploader
  mount_uploader :image_name_selection, ThemesImageSelectionUploader

  has_one :bundle
  has_many :users_themes


  # combine id and name to show in the (collection element) on the front-end
  def id_and_theme
    "#{id}. #{name}"
  end


end
