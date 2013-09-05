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
  attr_accessible  :description,
                   :image_name,
                   :item_id,
                   :name,
                   :image_name_hover,
                   :image_name_selection,
                   :category,
                   :style,
                   :brand,
                   :color,
                   :make,
                   :special_name,
                   :like,
                   :price,
                   :product_url



  mount_uploader :image_name, ItemsDesignsImageUploader
  mount_uploader :image_name_hover, ItemsDesignsImageHoverUploader
  mount_uploader :image_name_selection, ItemsDesignsImageSelectionUploader

  belongs_to :item
  validates_presence_of :item


  has_many :users_items_designs
  has_many :bundles_items_designs

  validates :name, presence:true
  validates :item_id, :numericality => { :only_integer => true }
  validates :like, :numericality => { :only_integer => true }
  validates :price,presence:true, numericality: true


  def id_and_item_design
    "#{id}. #{name}"
  end



end
