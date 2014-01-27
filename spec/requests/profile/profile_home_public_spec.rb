require 'spec_helper'

describe "backbone view profile", :js => true do


  before do
    @user =   User.last
    visit room_rooms_path(@user.username)
  end

  subject { page }

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

  describe "id = profileHome_container", tag_dom_profileHome_botton:true do

    it "should have profileHome botton" do
      page.should have_selector("div#profileHome_botton")
      page.should have_css("div#profileHome_botton")
    end

  end






end

