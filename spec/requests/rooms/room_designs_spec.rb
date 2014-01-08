require 'spec_helper'

describe "backbone view rooms", :js => true do

  #before(:all){ create_init_data }
  #after(:all){ delete_init_data }

  before do
    #@user = FactoryGirl.create(:user)
    #sign_in @user
    @user = FactoryGirl.create(:user)
    sign_in @user
    visit room_rooms_path(@user.username)
  end

  subject { page }


  describe "design_view" do
    before  do
      #visit room_rooms_path(@user.username)
      @items = Item.all
      #sleep 100

    end

    #it { page.find('#id').should have_content('loaded')}

                           #<img class="room_design"
    it {page.should have_selector('img.room_design')}

    it "should have all the items1" do
        page.should have_selector('div')
    end


    it "should have all the items" do

      @items.each do |item|
          selector = "div.room_design_container_"+item.id.to_s
         page.should have_selector(selector)
      end
    end

  end


end

