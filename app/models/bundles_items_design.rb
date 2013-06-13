class BundlesItemsDesign < ActiveRecord::Base
  attr_accessible :bundle_id, :items_design_id, :location_id

  belongs_to :bundle
  belongs_to :location
  belongs_to :items_design

  validates_presence_of :bundle
  validates_presence_of :location
  validates_presence_of :items_design

  validates :bundle_id,presence:true,:numericality => { :only_integer => true }
  validates :location_id,presence:true,:numericality => { :only_integer => true }
  validates :items_design_id,presence:true,:numericality => { :only_integer => true }




end
