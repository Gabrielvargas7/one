class Bookmark < ActiveRecord::Base
  attr_accessible :bookmark_url, :bookmarks_category_id, :description, :i_frame, :image_name, :image_name_desc, :item_id, :title
end
