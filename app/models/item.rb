# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  x           :decimal(, )
#  y           :decimal(, )
#  z           :integer
#  width       :integer
#  height      :integer
#  clickable   :string(255)
#  folder_name :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Item < ActiveRecord::Base
  attr_accessible :clickable, :folder_name, :height, :name, :width, :x, :y, :z

  has_many :items_designs
  has_many :bookmarks_categories
  has_many :bookmarks
  has_many :bundles_bookmarks
  has_many :items_locations

  VALID_YES_NO_REGEX = /(yes)|(no)/

  before_save { |item| item.clickable = clickable.downcase }

  validates :name,presence:true
  validates :clickable, presence:true, format: { with: VALID_YES_NO_REGEX }
  validates :height, presence:true, numericality: { only_integer: true }
  validates :width, presence:true, numericality: { only_integer: true }
  validates :x,presence:true, numericality: true
  validates :y,presence:true, numericality: true
  validates :z,presence:true, numericality: { only_integer: true }


  def id_and_item
    "#{id}. #{name}"
  end


end
