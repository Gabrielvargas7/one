# == Schema Information
#
# Table name: friend_requests
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  user_id_requested :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'spec_helper'

describe FriendRequest do

    # the (before) line will instance the variable for every (describe methods)
  before do
      @user1 = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user)
      @friend_request = FactoryGirl.build(:friend_request,user_id:@user1.id,user_id_requested:@user2.id)
      #@friend_request = FactoryGirl.create(:friend_request)
  end

  #the (subject)line declare the variable that is use in all the test
  subject { @friend_request }


  it { @friend_request.should respond_to(:user_id_requested) }
  it { @friend_request.should respond_to(:user_id) }
  it { @friend_request.should be_valid }



end
