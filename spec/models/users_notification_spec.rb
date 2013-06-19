# == Schema Information
#
# Table name: users_notifications
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  notification_id :integer          default(0)
#  notified        :string(255)      default("y"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe UsersNotification do
  # the (before) line will instance the variable for every (describe methods)
  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  before do
    @user = FactoryGirl.create(:user)
    @notification = FactoryGirl.create(:notification)

    @user_notification = FactoryGirl.build(:users_notification,user_id:@user.id,notification_id:@notification.id)

  end

  #the (subject)line declare the variable that is use in all the test
  subject { @user_notification }

  it { @user_notification.should respond_to(:notification_id) }
  it { @user_notification.should respond_to(:user_id) }
  it { @user_notification.should be_valid }




end
