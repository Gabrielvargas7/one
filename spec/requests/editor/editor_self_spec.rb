require 'spec_helper'

describe "backbone view rooms", :js => true do


  before do
    @user = User.last
    visit room_rooms_path(@user.username)
  end

  subject { page }


  #***********************************
  # rspec test  test all items in the editor
  #***********************************

  describe "design_view ", tag_dom_items: true do

    xit "should do something" do
      expect('thing').to be('thing')
    end
  end

end
