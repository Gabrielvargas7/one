class ItemsDesign < ActiveRecord::Base
  attr_accessible :bundle_id, :description, :image_name, :item_id, :name,:image_name_hover,:image_name_selection

  mount_uploader :image_name, ItemsDesignsImageUploader
  mount_uploader :image_name_hover, ItemsDesignsImageHoverUploader
  mount_uploader :image_name_selection, ItemsDesignsImageSelectionUploader

end
