# == Schema Information
#
# Table name: friends
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  user_id_friend :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'spec_helper'

describe Friend do

  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  # the (before) line will instance the variable for every (describe methods)
  before do
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @friend = FactoryGirl.build(:friend,user_id:@user1.id,user_id_friend:@user2.id)
    #@friend_request = FactoryGirl.create(:friend_request)
  end

  #the (subject)line declare the variable that is use in all the test
  subject { @friend }


  it { @friend.should respond_to(:user_id_friend) }
  it { @friend.should respond_to(:user_id) }
  it { @friend.should be_valid }


end
