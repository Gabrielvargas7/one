# == Schema Information
#
# Table name: bundles_items_designs
#
#  id              :integer          not null, primary key
#  items_design_id :integer
#  location_id     :integer
#  bundle_id       :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

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


  validate :bundle_and_location_belong_to_same_section


  def bundle_and_location_belong_to_same_section
    errors.add(:base, "bundle and location do not belong to same section") unless self.bundle.section_id == self.location.section_id
  end

end
