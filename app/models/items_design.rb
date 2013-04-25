class ItemsDesign < ActiveRecord::Base
  attr_accessible :bundle_id, :description, :image_name, :item_id, :name,:image_name_hover,:image_name_selection

  mount_uploader :image_name, ItemsDesignsImageUploader
  mount_uploader :image_name_hover, ItemsDesignsImageHoverUploader
  mount_uploader :image_name_selection, ItemsDesignsImageSelectionUploader

  belongs_to :item
  belongs_to :bundle

  has_many :users_items_designs

  validates_associated :item
  validates :item_id, :numericality => { :only_integer => true }



end
