class Tutorial < ActiveRecord::Base
  attr_accessible :description, :image_name, :name, :step

  mount_uploader :image_name, TutorialImageUploader

  validates :step,
            presence:true,
            uniqueness:{ case_sensitive: false }



end
