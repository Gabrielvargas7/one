class Location < ActiveRecord::Base
  attr_accessible :description, :height, :name, :section_id, :width, :x, :y, :z

  has_many :items_locations
  has_many :users_items_designs

  belongs_to :section

  validates_presence_of :section

  validates :section_id,presence:true,:numericality => { :only_integer => true }
  validates :name,presence:true
  validates :height, presence:true, numericality: { only_integer: true }
  validates :width, presence:true, numericality: { only_integer: true }
  validates :x,presence:true, numericality: true
  validates :y,presence:true, numericality: true
  validates :z,presence:true, numericality: { only_integer: true }


  def id_and_location_section
    "Location: #{id}. #{name} --Section: #{section_id}. #{section.name}"
  end



end
