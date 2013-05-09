# == Schema Information
#
# Table name: bookmarks
#
#  id                    :integer          not null, primary key
#  bookmarks_category_id :integer
#  item_id               :integer
#  bookmark_url          :text
#  title                 :string(255)
#  i_frame               :string(255)      default("y")
#  image_name            :string(255)
#  image_name_desc       :string(255)
#  description           :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class Bookmark < ActiveRecord::Base
  attr_accessible :bookmark_url, :bookmarks_category_id, :description, :i_frame, :image_name, :image_name_desc, :item_id, :title

  mount_uploader :image_name, BookmarkImageNameUploader
  mount_uploader :image_name_desc, BookmarkImageNameDescUploader

  belongs_to :item
  belongs_to :bookmarks_category
  has_many :bundles_bookmarks

  has_many :users_bookmarks

  validates_associated :item
  validates :item_id, :numericality => { :only_integer => true }


  def id_and_bookmark
    "#{id}. #{title} -iframe: #{i_frame} - #{bookmark_url}"
  end


end
