# == Schema Information
#
# Table name: items_designs
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  description          :text
#  item_id              :integer
#  bundle_id            :integer
#  image_name           :string(255)
#  image_name_hover     :string(255)
#  image_name_selection :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class ItemsDesign < ActiveRecord::Base
  attr_accessible :bundle_id, :description, :image_name, :item_id, :name,:image_name_hover,:image_name_selection

  mount_uploader :image_name, ItemsDesignsImageUploader
  mount_uploader :image_name_hover, ItemsDesignsImageHoverUploader
  mount_uploader :image_name_selection, ItemsDesignsImageSelectionUploader

  belongs_to :item
  belongs_to :bundle

  has_many :users_items_designs

  validates :name, presence:true
  validates_associated  :item
  validates_presence_of :item
  validates :item_id, :numericality => { :only_integer => true }

  def id_and_item_design
    "#{id}. #{name}"
  end



end
