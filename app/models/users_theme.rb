# == Schema Information
#
# Table name: users_themes
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  theme_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  section_id :integer
#

class UsersTheme < ActiveRecord::Base
  attr_accessible :theme_id, :user_id,:section_id
#softlink- you don't need theme to create usertheme
  belongs_to :theme
  belongs_to :user
  belongs_to :section

  #harder link. forces you to need theme before creating user theme.
  validates_presence_of :user
  validates_presence_of :theme
  validates_presence_of :section


  validates :user_id,presence:true, numericality: { only_integer: true }
  validates :theme_id,presence:true, numericality: { only_integer: true }
  validates :section_id,presence:true, numericality: { only_integer: true }




end
