# == Schema Information
#
# Table name: bundles
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  description    :text
#  theme_id       :integer
#  image_name     :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  image_name_set :string(255)
#

class Bundle < ActiveRecord::Base
  attr_accessible :description, :image_name, :name, :theme_id,:image_name_set,:section_id

  mount_uploader :image_name, BundlesImageUploader
  mount_uploader :image_name_set, BundlesImageSetUploader


  belongs_to :section
  belongs_to :theme
  has_many :items_designs


  validates_presence_of :theme
  validates_presence_of :section


  validates :name,presence:true
  validates :theme_id,presence:true, :numericality => { :only_integer => true }
  validates :section_id,presence:true,:numericality => { :only_integer => true }



  def id_and_bundle
    "#{id}. #{name}"
  end

end
