# == Schema Information
#
# Table name: users_photos
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  description   :string(255)
#  image_name    :string(255)
#  profile_image :string(255)      default("n")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class UsersPhoto < ActiveRecord::Base
  attr_accessible :description, :image_name, :profile_image, :user_id

  mount_uploader :image_name, UsersPhotosImageUploader

  belongs_to :user

  VALID_YES_NO_REGEX = /(y)|(n)/

  validates_presence_of :user

  validates :user_id, presence:true, numericality: { only_integer: true }
  validates :profile_image, presence: true, format: { with: VALID_YES_NO_REGEX }



end
