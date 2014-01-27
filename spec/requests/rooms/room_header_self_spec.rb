require 'spec_helper'

describe "backbone view rooms", :js => true do


  before do
    #@user = FactoryGirl.create(:user)
    @user =   User.find_by_email('test1@mywebroom.com')
    sign_in_with_password(@user,'rooms')
    visit room_rooms_path(@user.username)
  end

  subject { page }


  describe "header menu genaral elements", tag_dom_header_menu_general:true do

    it "should have rooms_header main_menu " do
      page.should have_selector("ul#rooms_header_main_menu")
      page.should have_css("ul#rooms_header_main_menu")
    end
    it "should have rooms_header xroom_header_li_element" do
      page.should have_selector("li.xroom_header_li_element")
    end

    it{page.should have_css("li.xroom_header_li_element", count: 3) }

  end

  describe "header menu xroom_header_li_element", tag_dom_header_menu_li_elements:true do

    it "should have rooms_header a#xroom_header_storepage" do
      page.should have_selector("a#xroom_header_storepage")
    end

    it "should have rooms_header a#xroom_header_storepage" do
      find("a#xroom_header_storepage").should be_visible
    end


    it "should have rooms_header xroom_header_profile" do
      page.should have_css("a#xroom_header_profile")
    end

    it "should have rooms_header xroom_header_profile" do
      find("a#xroom_header_profile").should be_visible
    end


    it "should have rooms_header a#xroom_header_active_sites" do
      page.should have_selector("a#xroom_header_active_sites")
    end

    it "should have rooms_header a#xroom_header_active_sites" do
      find("a#xroom_header_active_sites").should be_visible
    end

    it "should have rooms_header a#xroom_header_active_sites" do
      page.should have_selector("a#xroom_header_myroom")
    end




  end

  describe "header menu click elements on the header", tag_dom_header_menu_click:true do

    it { should have_css('div#xroom_storepage', :visible => false) }

    it "click on the profile, display should be true" do
      page.find("a#xroom_header_storepage").click
      page.should have_css('div#xroom_storepage', :visible => true)
    end

    it { should have_css('div#xroom_profile', :visible => false) }

    it "click on the profile, display should be true" do
      page.find("a#xroom_header_profile").click
      page.should have_css('div#xroom_profile', :visible => true)
    end


  end

  describe "header menu click dropdown menu", tag_dom_header_menu_click_dropdown:true do

    it "should have xroom_header_forward_profile" do
      page.find("a#xroom_header_user_room_dropdown-toggle").click
      page.should have_selector("a#xroom_header_forward_profile")
    end

    it "button text should be 'Profile' " do
      page.find("a#xroom_header_user_room_dropdown-toggle").click
      page.should have_css("#xroom_header_forward_profile", :text => "Profile")
    end

    it "should have xroom_header_forward_setting" do
      page.find("a#xroom_header_user_room_dropdown-toggle").click
      page.should have_selector("a#xroom_header_forward_setting")
    end

    it "button text should be 'Setting' " do
      page.find("a#xroom_header_user_room_dropdown-toggle").click
      page.should have_css("#xroom_header_forward_setting", :text => "Setting")
    end

    it "should have xroom_header_forward_help" do
      page.find("a#xroom_header_user_room_dropdown-toggle").click
      page.should have_selector("a#xroom_header_forward_help")
    end

    it "button text should be 'Help' " do
      page.find("a#xroom_header_user_room_dropdown-toggle").click
      page.should have_css("#xroom_header_forward_help", :text => "Help")
    end

    it "should have xroom_header_forward_Logout" do
      page.find("a#xroom_header_user_room_dropdown-toggle").click
      page.should have_selector("a#xroom_header_forward_logout")
    end

    it "button text should be 'Logout' " do
      page.find("a#xroom_header_user_room_dropdown-toggle").click
      page.should have_css("#xroom_header_forward_logout", :text => "Logout")
    end
  end



end

