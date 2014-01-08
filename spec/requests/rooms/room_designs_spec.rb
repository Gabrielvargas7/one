require 'spec_helper'

describe "backbone view rooms" do

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


  describe "design_view", :js => true  do
    #before  do
    #  #visit room_rooms_path(@user.username)
    #  @item = Item.first
    #  puts @item.id
    #  #sleep 100
    #
    #end

    #it { page.find('#id').should have_content('loaded')}
    #it { find('.room_design').should have_content('baz') }
    #                       #<img class="room_design"
    it {page.should have_selector('img.room_design')}

    #it {page.should have_selector('div.room_design_container_4')}


    #it "should have all the items" do
    #
    #  page.should have_selector("div.room_design_container_"+@item.id.to_s)
    #
    #  #@items.each do |item|
    #  #    selector = "div.room_design_container_"+item.id.to_s
    #  #   page.should have_selector(selector)
    #  #end
    #end

  end


end

