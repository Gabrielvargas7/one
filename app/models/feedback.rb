# == Schema Information
#
# Table name: feedbacks
#
#  id          :integer          not null, primary key
#  description :text
#  user_id     :integer
#  name        :string(255)
#  email       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Feedback < ActiveRecord::Base
  attr_accessible :description, :email, :name, :user_id



end
