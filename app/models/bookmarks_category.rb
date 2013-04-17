class BookmarksCategory < ActiveRecord::Base
  attr_accessible :item_id, :name

  belongs_to :item
  has_many :bookmarks

  validates_associated :item
  validates :item_id, :numericality => { :only_integer => true }


  def id_and_bookmark_category
    "#{id}. #{name}"
  end

end
