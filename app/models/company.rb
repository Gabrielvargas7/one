# == Schema Information
#
# Table name: companies
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  image_name  :string(255)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Company < ActiveRecord::Base
  attr_accessible :description, :image_name, :name

  mount_uploader :image_name, CompaniesImageNameUploader

  has_many :items_design

  validates :name,  uniqueness:{ case_sensitive: false }

  def id_and_company
    "#{id}. #{name}"
  end


end
