class Bookmark < ActiveRecord::Base
  attr_accessible :bookmark_url, :bookmarks_category_id, :description, :i_frame, :image_name, :image_name_desc, :item_id, :title

  mount_uploader :image_name, BookmarkImageNameUploader
  mount_uploader :image_name_desc, BookmarkImageNameDescUploader

end
