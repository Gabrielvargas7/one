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

  before_save { |item| item.clickable = clickable.downcase }

  validates :height, :numericality => { :only_integer => true }
  validates :width, :numericality => { :only_integer => true }
  validates :x, :numericality  => true
  validates :y, :numericality  => true
  validates :z, :numericality => { :only_integer => true }


  def id_and_item
    "#{id}. #{name}"
  end


end
