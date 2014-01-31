# == Schema Information
#
# Table name: static_contents
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  image_name  :string(255)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class StaticContent < ActiveRecord::Base
  attr_accessible :description, :image_name, :name

  mount_uploader :image_name, StaticContentsImageNameUploader

  validates :name,
            presence: true,
            uniqueness:{ case_sensitive: false }


end
