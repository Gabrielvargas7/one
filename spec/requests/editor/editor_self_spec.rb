require 'spec_helper'

describe "backbone view rooms", :js => true do


  before do
    @user =   User.find_by_email('test1@mywebroom.com')
    sign_in_with_password(@user,'rooms')
    visit room_rooms_path(@user.username)
  end

  subject { page }


  #***********************************
  # rspec test  test all items in the editor
  #***********************************

  describe "design_view ", tag_dom_items: true do


    it "click on the profile, display should be true" do
      page.find("a#xroom_header_storepage").click
      page.should have_css('div#xroom_storepage', :visible => true)
      page.should have_css('a#store_close_button', :visible => true)
    end

  end

end
