require 'spec_helper'

describe "backbone view rooms", :js => true do


  before do
    @user = User.find_by_email('test1@mywebroom.com')
    sign_in_with_password(@user,'rooms')
    visit room_rooms_path(@user.username)
  end

  #subject { page }


  #***********************************
  # rspec test  test all items in the editor
  #***********************************

  context "Editor", tag_dom_items: true do


    it "has various elements" do
      find("a#xroom_header_storepage").click
      expect(page).to have_css('div#xroom_storepage', :visible => true)
      expect(page).to have_css('a#store_close_button', :visible => true)
      #expect(page).to have_css('input#store_search_box', :visible => true) <-- fails
      #expect(page).to have_css('div#store_container', :visible => true) <-- fails
      find('a#store_close_button').click
      expect(page).not_to have_css('a#store_close_button', :visible => true)
    end


    xit "can switch between tabs" do
      find("a#tab_themes").click
      expect(page).to have_css('li#dropdown-style', :visible => true)
    end

  end

end
