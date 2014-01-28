require 'spec_helper'

describe "requests room header public ", :js => true do


  before do
    @user =   User.last
    #sign_in @user
    visit room_rooms_path(@user.username)
  end

  subject { page }


  describe "header menu", tag_dom_header_menu:true do

    it "should have rooms_header main_menu " do
      page.should have_selector("ul#rooms_header_main_menu")
      page.should have_css("ul#rooms_header_main_menu")
    end

    it "should have rooms_header main_login button " do
      page.should have_selector("li.xroom_header_li_login_btn")
      page.should have_css("li.xroom_header_li_login_btn")
      find("li.xroom_header_li_login_btn").should be_visible
    end

    it "should have rooms_header main_login button a = 'LOGIN' " do
      find('li.xroom_header_li_login_btn a', :text => "LOGIN")
    end


    it "should have rooms_header xroom_header_li_sign_up_btn" do
      page.should have_selector("li.xroom_header_li_sign_up_btn")
      page.should have_css("li.xroom_header_li_sign_up_btn")
      find("li.xroom_header_li_sign_up_btn").should be_visible
    end

    it "should have rooms_header main_sign up button a = 'SIGN UP' " do
      find('li.xroom_header_li_sign_up_btn a', :text => "SIGN UP")
    end


  end




end

