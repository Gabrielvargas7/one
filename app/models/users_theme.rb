# == Schema Information
#
# Table name: users_themes
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  theme_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UsersTheme < ActiveRecord::Base
  attr_accessible :theme_id, :user_id

  belongs_to :theme
  belongs_to :user

  validates_presence_of :user
  validates_presence_of :theme

  validates :user_id,presence:true, numericality: { only_integer: true }
  validates :theme_id,presence:true, numericality: { only_integer: true }



end
