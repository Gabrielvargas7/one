# Given I am in my room
# And there are no notifications
# When I click 'Editor'
# Then the editor opens



# Given I am in my room
# And my couch is visible
# And I have already clicked it previously
# When I click on my couch
# Then the bookmarks interface opens




require 'spec_helper'



feature 'In existing users room' do


  background { visit '/room/dave' }

  # scenario 'i visit my room' do
  #   expect(page.title).to have_content('My Room')
  # end


  scenario 'i click on editor', :js => true do
    #find('#xroom_header_storepage')
    expect(page).to have_content('Dave')
    #click_on('Editor')
  end

end




# fails b/c email already exists
# feature 'In factory users room' do


#   background { user = FactoryGirl.create(:user) }
#   background { visit room_rooms_path(user) }

#   scenario 'i visit my room' do
#     expect(page.title).to have_content('My Room')
#     expect(page).to have_content('Editor')
#   end

# end
