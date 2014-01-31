# == Schema Information
#
# Table name: bundles
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  description            :text
#  theme_id               :integer
#  image_name             :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  image_name_set         :string(255)
#  section_id             :integer
#  active                 :string(255)      default("n")
#  category               :string(255)
#  style                  :string(255)
#  brand                  :string(255)
#  location               :string(255)
#  color                  :string(255)
#  make                   :string(255)
#  special_name           :string(255)
#  like                   :integer          default(0)
#  image_name_entire_room :string(255)
#

class Bundle < ActiveRecord::Base
  attr_accessible :description,
                  :image_name,
                  :name,
                  :theme_id,
                  :image_name_set,
                  :section_id,
                  :active,
                  :category,
                  :style,
                  :brand,
                  :location,
                  :color,
                  :make,
                  :special_name,
                  :like,
                  :image_name_entire_room

  mount_uploader :image_name, BundlesImageUploader
  mount_uploader :image_name_set, BundlesImageSetUploader
  mount_uploader :image_name_entire_room,BundlesImageNameEntireRoomUploader


  belongs_to :section
  belongs_to :theme
  #has_many :items_designs
  has_many :bundles_items_designs

  VALID_Y_N_REGEX = /(y)|(n)/


  validates_presence_of :theme
  validates_presence_of :section

  VALID_REGEX = /^(?:[^\W_]|\s)*$/u
  validates :name,presence:true,
            #uniqueness:{ case_sensitive: false },
            #format: { with: VALID_REGEX },
            length: {minimum: 1, maximum: 100},
            allow_blank: false
  validates :active, presence:true, format: { with: VALID_Y_N_REGEX }
  #validates :name,presence:true
  validates :theme_id,presence:true, :numericality => { :only_integer => true }
  validates :section_id,presence:true,:numericality => { :only_integer => true }
  validates :like, :numericality => { :only_integer => true }



  def id_and_bundle
    "#{id}. #{name}"
  end

  def id_and_bundle_section
    "Bundle: #{id}. #{name} -- Section: #{section.id}.#{section.name}"
  end




end
