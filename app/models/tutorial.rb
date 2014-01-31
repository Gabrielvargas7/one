# == Schema Information
#
# Table name: tutorials
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  image_name  :string(255)
#  description :string(255)
#  step        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Tutorial < ActiveRecord::Base
  attr_accessible :description, :image_name, :name, :step

  mount_uploader :image_name, TutorialImageUploader

  validates :step,
            presence:true,
            uniqueness:{ case_sensitive: false }



end
