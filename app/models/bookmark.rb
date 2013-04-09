class Bookmark < ActiveRecord::Base
  attr_accessible :bookmark_url, :bookmarks_category_id, :i_frame, :image_name, :title
end
