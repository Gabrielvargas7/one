require 'spec_helper'

describe "User pages" do

  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  before do
    #@user = FactoryGirl.create(:user)
    #sign_in @user
    @admin = FactoryGirl.create(:admin)
    sign_in @admin
  end

  subject { page }

  describe "index" do

    before  do
      visit room_rooms_path(@user.username)
    end


    it { page.should have_selector('title', text: 'My Room') }
    #it { page.should have_selector('h1',    text: 'All users') }

  end
end