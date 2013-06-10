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
    @theme = FactoryGirl.create(:theme)

    @user_theme = FactoryGirl.build(:users_theme,user_id:@user.id,theme_id:@theme.id)
    #@friend_request = FactoryGirl.create(:friend_request)
  end

  #the (subject)line declare the variable that is use in all the test
  subject { @user_theme }

  it { @user_theme.should respond_to(:theme_id) }
  it { @user_theme.should respond_to(:user_id) }
  it { @user_theme.should be_valid }



end
