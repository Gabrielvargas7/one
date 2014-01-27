require 'spec_helper'

describe "backbone view rooms", :js => true do


  before do
    @user =   User.last
    #sign_in @user
    visit room_rooms_path(@user.username)
  end

  subject { page }

  describe "header logo", tag_dom_header_logo:true do


    it "should have id #xroom_header_logo" do
      page.should have_selector("#xroom_header_logo")
      page.should have_css("a#xroom_header_logo")
    end

    it "should have the atl logo-mywebroom" do
      find('#xroom_header_logo img')['alt'].should == "logo-mywebroom"
    end

  end



  describe "header search", tag_dom_header_search:true do

    it "should have id #xroom_header_search" do
        page.should have_selector("#xroom_header_search")
        page.should have_css("input#xroom_header_search_text")
    end

    it "should have text" do
      find('#xroom_header_search_text')['placeholder'].should == "Search for people, objects and bookmarks"
    end

    it "button text should be ALL " do
      page.should have_css("button#header-search-dropdown-btn", :text => "ALL")
    end
  end

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

    it "should have rooms_header main_sign up button a = 'SIGN UP' " do
      find('li.xroom_header_li_sign_up_btn a')['href'].should == "/select-room"
    end



  end




end

