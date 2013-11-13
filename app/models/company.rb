class Company < ActiveRecord::Base
  attr_accessible :description, :image_name, :name

  mount_uploader :image_name, CompaniesImageNameUploader

  has_many :items_design

  validates :name,  uniqueness:{ case_sensitive: false }

  def id_and_company
    "#{id}. #{name}"
  end


end
