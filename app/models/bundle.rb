class Bundle < ActiveRecord::Base
  attr_accessible :description, :image_name, :name, :theme_id

  mount_uploader :image_name, BundlesImageUploader

  belongs_to :theme
  has_many :items_designs

  validates_associated :theme
  validates :theme_id, :numericality => { :only_integer => true }


  def id_and_bundle
    "#{id}. #{name}"
  end

end
