# == Schema Information
#
# Table name: bookmarks_categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  item_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BookmarksCategory < ActiveRecord::Base
  attr_accessible :item_id, :name

  belongs_to :item
  has_many :bookmarks


  validates_associated  :item
  validates_presence_of :item

  validates :item_id, :numericality => { :only_integer => true }
  validates :name, presence:true


  def id_and_bookmark_category
    "#{id}. #{name}"
  end

end
