class BundlesBookmark < ActiveRecord::Base
  attr_accessible :bookmark_id, :item_id

  belongs_to :bookmark
  belongs_to :item
end
