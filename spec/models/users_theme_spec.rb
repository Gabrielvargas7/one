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

  # the (before) line will instance the variable for every (describe methods)
  before do
    @user = FactoryGirl.create(:user)
    @section = FactoryGirl.create(:section)
    @theme = FactoryGirl.create(:theme)

    @user_theme = FactoryGirl.build(:users_theme,user_id:@user.id,theme_id:@theme.id,section_id:@section.id)
    #@friend_request = FactoryGirl.create(:friend_request)
  end

  #the (subject)line declare the variable that is use in all the test
  subject { @user_theme }

  it { @user_theme.should respond_to(:theme_id) }
  it { @user_theme.should respond_to(:user_id) }
  it { @user_theme.should respond_to(:section_id) }

  it { @user_theme.should be_valid }



  ###############
  #test validation section is present
  ###############
  describe " id section id ",tag_section_id:true do
    it "should be valid " do
      @user_theme.section_id = @section.id
    end
  end

  ###############
  #test validation section id is not valid
  ###############

  describe "should not be valid ids ",tag_section_id:true do
    let(:users_theme_not_section_id){FactoryGirl.build(:users_theme,user_id:@user.id,theme_id:@theme.id,section_id:-1)}
    it { users_theme_not_section_id.should_not be_valid }


  end



end
