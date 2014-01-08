require 'spec_helper'

describe "room page" do

  #before(:all){ create_init_data }
  #after(:all){ delete_init_data }

  before do
    #@user = FactoryGirl.create(:user)
    #sign_in @user
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  subject { page }


  describe "rails room view " do
    before  do
      visit room_rooms_path(@user.username)
    end

    it {page.should have_selector('div#xroom_main_container')}
    it {page.should have_selector('div#xroom_scroll_left')}
    it {page.should have_selector('div#xroom_store_menu_save_cancel_remove')}
    it {page.should have_selector('div#xroom_profile')}
    it {page.should have_selector('div#xroom_storepage')}
    it {page.should have_selector('div#xroom_bookmarks')}
    it {page.should have_selector('div#xroom_bookmarks_browse_mode')}
    it {page.should have_selector('div#xroom_footer')}
    it {page.should have_selector('div#xroom_scroll_right')}
    it {page.should have_selector('div#xroom_tutorial_container')}
    it {page.should have_selector('div#xroom_popup_container')}
    it {page.should have_selector('div#xroom_scroll_left')}
    it {page.should have_selector('div#xroom')}
    it {page.should have_selector('div#xroom_items_0')}
    it {page.should have_selector('div#xroom_items_1')}
    it {page.should have_selector('div#xroom_items_2')}



  end


end

