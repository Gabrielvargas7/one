# == Schema Information
#
# Table name: users_galleries
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  image_name :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UsersGallery < ActiveRecord::Base
  attr_accessible :image_name, :default_image, :user_id

  mount_uploader :image_name, UsersGalleriesImageUploader

  belongs_to :user

end
