class BundlesBookmark < ActiveRecord::Base
  attr_accessible :bookmark_id, :item_id

  belongs_to :bookmark
  belongs_to :item

  validates_associated :item
  validates :item_id, :numericality => { :only_integer => true }

  validates_associated :bookmark
  validates :bookmark_id_id, :numericality => { :only_integer => true }


end
