require 'spec_helper'

def social_bar_spec_helper 
  #page.first(".gridItem").hover
  page.should have_css(".gridItem .social_bar", :visible => true)
  page.should have_css(".social_bar .fb_like_item", :visible => true)
  page.should have_selector(".social_bar .pinterest_item")
  page.should have_selector(".social_bar .info_button_item")
end

describe "requests profile home public ", :js => true do


  before do
    @user =   User.last
    visit room_rooms_path(@user.username)
  end

  subject { page }

  describe "profile click " , tag_click_profile:true do
    
    el_ask_for_key_btn = "#profile_ask_for_key_overlay button.profile_request_key_button"

    describe "Home" do
      it "should have Request Key button" do
        el_request_key_btn = "button.profile_request_key_button"
        page.should have_css(el_request_key_btn, :visible => true)
      end

      it "should show social on grid item hover" do
        page.first(".gridItem").hover
        page.should have_css(".gridItem .social_bar", :visible => true)
        page.should have_css(".social_bar .fb_like_item", :visible => true)
        page.should have_selector(".social_bar .pinterest_item")
        page.should have_selector(".social_bar .info_button_item")
      end      
    end

    describe "Photos" do
      
      el_photos = "li#profile_photos"
      el_photos_view = "div.user-photos-view"
      
      before do
        page.find(el_photos).click
      end

      it "should show the Photos" do

        page.should have_css(el_ask_for_key_btn, :visible => true)
        page.should have_selector(el_photos_view)
      end

    end

    describe "Objects" do
      el_objects = "li#profile_objects"
      el_objects_view = "div.profile_objects_view"

      it "should show Objects" do
        page.find(el_objects).click

        page.should have_css(el_ask_for_key_btn, :visible => true)
        page.should have_selector(el_objects_view)
      end

      it "should show social on grid item hover" do
        page.first(".gridItem").hover
        page.should have_css(".gridItem .social_bar", :visible => true)
        page.should have_css(".social_bar .fb_like_item", :visible => true)
        page.should have_selector(".social_bar .pinterest_item")
        page.should have_selector(".social_bar .info_button_item")
      end
    end

    describe "Bookmarks" do
      el_bookmarks = "li#profile_bookmarks"
      el_bookmarks_view = "div.profile_bookmarks_view"

      it "should show Bookmarks" do
        page.find(el_bookmarks).click
        page.should have_css(el_ask_for_key_btn, :visible => true)
        page.should have_selector(el_bookmarks_view)
      end

      it "should show social on grid item hover" do
        page.first(".gridItem").hover
        page.should have_css(".gridItem .social_bar", :visible => true)
        page.should have_css(".social_bar .fb_like_item", :visible => true)
        page.should have_selector(".social_bar .pinterest_item")
        page.should have_selector(".social_bar .info_button_item")
      end
    end

    describe "Activity" , tag_click_activity:true do
      el_activity = "li#profile_activity"
      el_activity_view = "#profileHome_bottom .profileActivity_activity.generalGrid"

      before do
        page.find(el_activity).click
      end

      it "should show Activity" do
        
        page.should have_css(el_ask_for_key_btn, :visible => true)
        page.should have_selector(el_activity_view)
      end

      it "should show social on grid item hover" do
        page.first(".gridItem").hover
        page.should have_css(".gridItem .social_bar", :visible => true)
        page.should have_css(".social_bar .fb_like_item", :visible => true)
        page.should have_selector(".social_bar .pinterest_item")
        page.should have_selector(".social_bar .info_button_item")
      end

    end

    describe "Friends" do
      it "should not be visible in sidebar" do
        el_friends = "li#profile_friends"
        
      end
    end

    describe "Requests" do
      it "should not be visible in sidebar" do
        el_requests = "li#profile_key_requests"
        page.should_not have_selector(el_requests)
      end
    end

  end #

  describe "profile general class", tag_dom_profile_general:true do

    it "should have id #profile_home_container" do

      page.should have_selector("#profile_home_container")
      page.should have_css("#profile_home_container")

    end

    it "should have id #profile_sidebar" do
      page.should have_selector("#profile_sidebar")
      page.should have_css("#profile_sidebar")
    end

    it "should have id #profileHome_container" do
      page.should have_selector("#profileHome_container")
      page.should have_css("#profileHome_container")
    end

  end

  describe "id = profile_sidebar", tag_dom_profile_sidebar:true do

    it "should have profile home button" do
      page.should have_selector("li#profile_home")
      page.should have_css("li#profile_home")
    end

    it "should have profile home button" do
      find('li#profile_home a', :text => "HOME")
    end

    it "should have profile photos button" do
      page.should have_selector("li#profile_photos")
      page.should have_css("li#profile_photos")
    end

    it "should have profile photos button" do
      find('li#profile_photos a', :text => "PHOTOS")
    end

    it "should have profile objects button" do
      page.should have_selector("li#profile_objects")
      page.should have_css("li#profile_objects")
    end

    it "should have profile objects button" do
      find('li#profile_objects a', :text => "OBJECTS")
    end

    it "should have profile bookmarks button" do
      page.should have_selector("li#profile_bookmarks")
      page.should have_css("li#profile_bookmarks")
    end

    it "should have profile bookmarks button" do
      find('li#profile_bookmarks a', :text => "BOOKMARKS")
    end

    it "should have profile activity button" do
      page.should have_selector("li#profile_activity")
      page.should have_css("li#profile_activity")
    end

    it "should have profile activity button" do
      find('li#profile_activity a', :text => "ACTIVITY")
    end
  end


  describe "id = profileHome_container", tag_dom_profileHome_top:true do

    it "should have profileHome top" do
      page.should have_selector("div#profileHome_top")
      page.should have_css("div#profileHome_top")
    end


  end

  describe "id = profileHome_container", tag_dom_profileHome_bottom:true do

    it "should have profileHome bottom" do
      page.should have_selector("div#profileHome_bottom")
      page.should have_css("div#profileHome_bottom")
    end

  end

end

