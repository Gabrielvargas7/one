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


  describe "user_id_friend", tag_user_friend:true do

    before do
      @user3 = FactoryGirl.create(:user)
      @user4 = FactoryGirl.create(:user)
    end
    it "creates a new User Friend #add_one_friend" do

      expect {
        @friend2 = FactoryGirl.create(:friend,user_id:@user3.id,user_id_friend:@user4.id)
      }.to change(Friend, :count).by(1)
    end

    it "not changes #user_id_friend_exist" do

      expect {
        @friend2 = FactoryGirl.create(:friend,user_id:@user3.id,user_id_friend:1)
      }.to raise_error
    end

  end



end
