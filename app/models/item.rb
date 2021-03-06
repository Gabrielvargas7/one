# == Schema Information
#
# Table name: items
#
#  id                          :integer          not null, primary key
#  name                        :string(255)
#  clickable                   :string(255)      default("yes")
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  image_name                  :string(255)
#  priority_order              :integer          default(0)
#  image_name_gray             :string(255)
#  image_name_first_time_click :string(255)
#  name_singular               :string(255)
#

class Item < ActiveRecord::Base
  attr_accessible :clickable,:name, :name_singular ,:priority_order,:image_name,:image_name_gray,:image_name_first_time_click


  has_many :items_designs
  has_many :bookmarks_categories
  has_many :bookmarks
  has_many :bundles_bookmarks
  has_many :items_locations


  VALID_REGEX = /^(?:[^\W_]|\s)*$/u

  mount_uploader :image_name, ItemsImageUploader
  mount_uploader :image_name_gray, ItemsImageGrayUploader
  mount_uploader :image_name_first_time_click, ItemsImageNameFirstTimeClickUploader



  VALID_YES_NO_REGEX = /(yes)|(no)/

  before_save { |item| item.clickable = clickable.downcase }

  validates :name,
            presence:true,
            #uniqueness:{ case_sensitive: false },
            #format: { with: VALID_REGEX } ,
            length: {minimum: 1, maximum: 100},
            allow_blank: false

  validates :name_singular,
            presence:true,
            length: {minimum: 1, maximum: 100},
            allow_blank: false


  validates :clickable, presence:true, format: { with: VALID_YES_NO_REGEX }

  validates :priority_order,presence:true, numericality: true


  def id_and_item
    "#{id}. #{name}"
  end


end
