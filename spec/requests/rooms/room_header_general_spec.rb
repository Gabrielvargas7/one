require 'spec_helper'

describe "requests `room_header general", :js => true do


  before do
    @user =   User.last
    #sign_in @user
    visit room_rooms_path(@user.username)
  end

  subject { page }

  #*******************************
  # Testing the logo
  #*******************************

  describe "header logo", tag_dom_header_logo:true do


    it "should have id #xroom_header_logo" do
      page.should have_selector("#xroom_header_logo")
      page.should have_css("a#xroom_header_logo")
    end

    it "should have the atl logo-mywebroom" do
      find('#xroom_header_logo img')['alt'].should == "logo-mywebroom"
    end

  end

  #*******************************
  # Testing the Search box
  #*******************************


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

  #*******************************
  # Testing the Search Button
  #*******************************

  describe "header search click button", tag_dom_header_search_click:true do

    it "should have  header-search-dropdown-all " do
      page.find("button.btn.dropdown-toggle").click
      page.should have_selector("li#header-search-dropdown-all")
    end

    it "button text should be 'ALL' " do
      page.find("button.btn.dropdown-toggle").click
      page.should have_css("li#header-search-dropdown-all", :text => "ALL")
    end

    it "should have  header-search-dropdown-bookmarks " do
      page.find("button.btn.dropdown-toggle").click
      page.should have_selector("li#header-search-dropdown-bookmarks")
    end

    it "button text should be 'BOOKMARKS' " do
      page.find("button.btn.dropdown-toggle").click
      page.should have_css("li#header-search-dropdown-bookmarks", :text => "BOOKMARKS")
    end


    it "should have  header-search-dropdown-objects " do
      page.find("button.btn.dropdown-toggle").click
      page.should have_selector("li#header-search-dropdown-objects")
    end

    it "button text should be 'BOOKMARKS' " do
      page.find("button.btn.dropdown-toggle").click
      page.should have_css("li#header-search-dropdown-objects", :text => "OBJECTS")
    end

    it "should have  header-search-dropdown-objects " do
      page.find("button.btn.dropdown-toggle").click
      page.should have_selector("li#header-search-dropdown-people")
    end

    it "button text should be 'BOOKMARKS' " do
      page.find("button.btn.dropdown-toggle").click
      page.should have_css("li#header-search-dropdown-people", :text => "PEOPLE")
    end

  end


  #*******************************
  # Testing the Search Box
  #*******************************
  describe "header search type something on the box", tag_dom_header_search_type:true do

    it { should have_css('div#xroom_header_search_box', :visible => false) }

    it "enter some text on the search box" do
      page.find('input#xroom_header_search_text').set("blue")
      page.should have_css('div#xroom_header_search_box', :visible => true)
    end
  end




end

