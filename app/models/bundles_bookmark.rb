# == Schema Information
#
# Table name: bundles_bookmarks
#
#  id          :integer          not null, primary key
#  item_id     :integer
#  bookmark_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class BundlesBookmark < ActiveRecord::Base
  attr_accessible :bookmark_id, :item_id

  belongs_to :bookmark
  belongs_to :item


  validates_presence_of :item
  validates :item_id, :numericality => { :only_integer => true }


  validates_presence_of :bookmark
  validates :bookmark_id, :numericality => { :only_integer => true }


end
