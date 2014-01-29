require 'spec_helper'



#*****************
# Helper Functions
#*****************
def login
  @user = User.find_by_email('sherrie@mywebroom.com')
  sign_in_with_password(@user, '12345678')
end



def open_editor
  find("a#xroom_header_storepage").click
end



def login_and_visit_self
  @user = User.find_by_email('sherrie@mywebroom.com')
  login
  visit room_rooms_path(@user.username)
end



def login_and_visit_friend
  login
  visit room_rooms_path('isadore-hessel-87097-90754')
end



def login_and_visit_public
  login
  visit room_rooms_path('dave')
end



def logout_and_visit_public
  sign_out
  visit room_rooms_path('dave')
end









#***********************************
# capybara test editor functionality
#***********************************
describe "Room Editor", :js => true do


  context "Signed In", tag_signed_in: true do


    context "Self", tag_self: true do

      before do
        login_and_visit_self
        open_editor
      end

      it "is visible" do
        expect(page).to have_css('div#store_main_box', :visible => true)
      end


      it "has the close button" do
        expect(page).to have_css('a#store_close_button', :visible => true)
      end


      it "has the collapse button" do
        expect(page).to have_css('a#store_collapse_button', :visible => true)
      end


      it "has a header" do
        expect(page).to have_css('ul#storeTabs')
      end


      it "has a content section" do
        expect(page).to have_css('div.tab-content', :visible => true)
      end


      it "can be collapsed and un-collapsed" do
        find('a#store_collapse_button').click
        expect(page).to have_css('div#store_main_box', :visible => false)
        find('a#store_collapse_button').click
        expect(page).to have_css('div#store_main_box', :visible => true)
      end


      it "displays items by default" do
        expect(page).to have_css('div#store_ITEM_container_2', :visible => true)
      end


      it "can switch to themes tab" do
        find(:xpath, "//a[@href='#tab_themes']").click
        expect(page).to have_css('div#store_THEME_container_1', :visible => true)
      end


      it "can switch to the bundles tab" do
        find(:xpath, "//a[@href='#tab_bundles']").click
        expect(page).to have_css('div#store_BUNDLE_container_16', :visible => true)
      end


      it "can switch to the entire rooms tab", tag_current: true do
        find(:xpath, "//a[@href='#tab_entire_rooms']").click
        expect(page).to have_css('div#store_ENTIRE_ROOM_container_16', :visible => true)
        expect(page).to have_css('a#xroom_store_save', :visible => false)

        # We can click a theme
        find('div#store_ENTIRE_ROOM_container_16').hover
        find('div#store_ENTIRE_ROOM_container_16 img.store_image_cell').click
        expect(page).to have_css('a#xroom_store_save', :visible => true)
        expect(page).to have_css('a#xroom_store_cancel', :visible => true)

        # We can click cancel
        find('a#xroom_store_cancel').click
        expect(page).to have_css('div.modal-footer', :visible => true)

        # Clicking OK closes the modal
        find('a.btn.btn-primary').click
        expect(page).to have_css('div.modal-footer', :visible => false)
      end


      it "has a search box" do
        expect(page).to have_css('input#store-search-box', :visible => true)
      end


      it "can be closed" do
        find('a#store_close_button').click
        expect(page).to have_css('div#store_main_box', :visible => false)
      end

    end




    context "Friend", tag_friend: true do

      before do
        login_and_visit_friend
      end


      it "has no editor button" do
        expect(page).not_to have_css("a#xroom_header_storepage")
      end

      it "does not display the editor" do
        expect(page).not_to have_css('div#store_main_box')
      end

    end




    context "Public", tag_public: true do

      before do
        login_and_visit_public
      end


      it "has no editor button" do
        expect(page).not_to have_css("a#xroom_header_storepage")
      end

      it "does not display the editor" do
        expect(page).not_to have_css('div#store_main_box')
      end

    end

  end



  context "Signed Out", tag_signed_out: true do

    before do
      logout_and_visit_public
    end

    it "has no editor button" do
      expect(page).not_to have_css("a#xroom_header_storepage")
    end

    it "does not display the editor" do
      expect(page).not_to have_css('div#store_main_box')
    end

  end



end
