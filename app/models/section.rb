# == Schema Information
#
# Table name: sections
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Section < ActiveRecord::Base
  attr_accessible :description, :name

  has_many :locations
  has_many :bundles
  has_many :users_themes

  validates :name, presence:true

  def id_and_section
    "#{id}. #{name}"
  end


end
