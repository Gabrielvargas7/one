# == Schema Information
#
# Table name: users_profiles
#
#  id                      :integer          not null, primary key
#  firstname               :string(255)
#  lastname                :string(255)
#  gender                  :string(255)
#  description             :string(255)
#  city                    :string(255)
#  country                 :string(255)
#  birthday                :date
#  user_id                 :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  friends_number          :integer          default(0)
#  tutorial_step           :integer          default(0)
#  password_reset_on_login :boolean          default(FALSE)
#

class UsersProfile < ActiveRecord::Base
  attr_accessible :birthday,
                  :city,
                  :country,
                  :description,
                  :firstname,
                  :gender,
                  :lastname,
                  :user_id,
                  :friends_number,
                  :tutorial_step,
                  :password_reset_on_login


  belongs_to :user
  validates_presence_of :user

end
