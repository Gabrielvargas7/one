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

require 'spec_helper'

describe UsersProfile do


  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  # the (before) line will instance the variable for every (describe methods)
  before do
    @user = FactoryGirl.create(:user)
    @user_profile = UsersProfile.find_all_by_user_id(@user.id).first
    #@friend_request = FactoryGirl.create(:friend_request)
  end

  #the (subject)line declare the variable that is use in all the test
  subject { @user_profile }

  it { @user_profile.should respond_to(:firstname) }
  it { @user_profile.should respond_to(:lastname) }
  it { @user_profile.should respond_to(:birthday) }
  it { @user_profile.should respond_to(:city) }
  it { @user_profile.should respond_to(:country) }
  it { @user_profile.should respond_to(:gender) }
  it { @user_profile.should respond_to(:user_id) }
  it { @user_profile.should respond_to(:friends_number) }

  it { @user_profile.should be_valid }



  ###############
  #test validation section is present
  ###############
  describe " id user id ",tag_user_id:true do
    it "should be present " do
      @user_profile.user_id.should eq(@user.id)
    end
  end



end
