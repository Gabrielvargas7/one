# == Schema Information
#
# Table name: users_items_designs
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  items_design_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  hide            :string(255)
#

class UsersItemsDesign < ActiveRecord::Base
  attr_accessible :items_design_id, :user_id ,:hide

  belongs_to :user
  belongs_to :items_design

  validates_presence_of :user
  validates_presence_of :items_design

  VALID_Y_N_REGEX = /(y)|(n)/
  validates :user_id,presence:true, numericality: { only_integer: true }
  validates :items_design_id,presence:true, numericality: { only_integer: true }
  validates :hide,presence:true, format: { with: VALID_Y_N_REGEX }

end
