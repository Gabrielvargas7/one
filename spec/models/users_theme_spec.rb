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

require 'spec_helper'

describe UsersTheme do

  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  # the (before) line will instance the variable for every (describe methods)
  before do
    @user = FactoryGirl.create(:user)
    @section = FactoryGirl.create(:section)
    @theme = FactoryGirl.create(:theme)

    @user_theme = FactoryGirl.build(:users_theme, user_id: @user.id, theme_id: @theme.id, section_id: @section.id)
    # @friend_request = FactoryGirl.create(:friend_request)
  end

  #the (subject) line declare the variable that is use in all the test
  subject { @user_theme }

  it { @user_theme.should respond_to(:theme_id) }
  it { @user_theme.should respond_to(:user_id) }
  it { @user_theme.should respond_to(:section_id) }

  it { @user_theme.should be_valid }



  ###############
  #test validation: user, theme, section
  ###############
  describe "user_id, theme_id, section_id", tag_validation_of_ids: true do
    it "should exist and be Fixnum's " do
      expect(@user_theme.user_id).not_to be nil
      expect(@user_theme.user_id).to be_an_instance_of(Fixnum)

      expect(@user_theme.theme_id).not_to be nil
      expect(@user_theme.theme_id).to be_an_instance_of(Fixnum)

      expect(@user_theme.section_id).not_to be nil
      expect(@user_theme.section_id).to be_an_instance_of(Fixnum)
    end
  end



  ###############
  #test validation section id is not valid
  ###############

  describe "ids should correspond to models that exist", tag_positive_ids: true do
    let(:users_theme_bad_user_id){ FactoryGirl.build(:users_theme, user_id: -1, theme_id: @theme.id, section_id: @section.id) }
    let(:users_theme_bad_theme_id){ FactoryGirl.build(:users_theme, user_id: @user.id, theme_id: -1, section_id: @section.id) }
    let(:users_theme_bad_section_id){ FactoryGirl.build(:users_theme, user_id: @user.id, theme_id: @theme.id, section_id: -1) }

    it { users_theme_bad_user_id.should_not be_valid }
    it { users_theme_bad_theme_id.should_not be_valid }
    it { users_theme_bad_section_id.should_not be_valid }
  end

end
