class ItemsLocation < ActiveRecord::Base
  attr_accessible :item_id, :location_id

  belongs_to :item
  belongs_to :location

  validates_presence_of :location
  validates_presence_of :item

  validates :item_id,presence:true,:numericality => { :only_integer => true }
  validates :location_id,presence:true,:numericality => { :only_integer => true }



  def item_location_section
    "Item: #{item.id}. #{item.name}  --Location:: #{location.id}. #{location.name} --Section: #{location.section.id}. #{location.section.name} "
  end


end
