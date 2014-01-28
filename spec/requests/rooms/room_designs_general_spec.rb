require 'spec_helper'

describe "requests room design general ", :js => true do


  before do
    @user =   User.last
    visit room_rooms_path(@user.username)
    @id_xroom_items_0 = "#xroom_items_0";
    @id_xroom_items_1 = "#xroom_items_1";
    @id_xroom_items_2 = "#xroom_items_2";
  end

  subject { page }

  #***********************************
  # rspec test  test all items on the room
  #***********************************


  describe "design_view ", tag_dom_items:true do
    before do
      #@items = Item.all
      #@user_items_designs = UsersItemsDesign.find_all_by_user_id(@user.id)
    end

    it {page.should have_selector('div#xroom_items_0')}
    it {page.should have_selector('div#xroom_items_1')}
    it {page.should have_selector('div#xroom_items_2')}
    #it { should have_css('div#xroom_items_2', :visible => true) }


    it "should have all the items and three time on the dom" do

      @items.each do |item|
        selector = "div.room_design_container_"+item.id.to_s
        page.should have_selector(selector)
        page.should have_css(selector, count: 3)

      end
    end

    it "should have data-id and three time on the dom" do


      @user_items_designs.each do |user_items_design|

          item = ItemsDesign.find(user_items_design.items_design_id)


          class_on_dom_room_design_container = "div.room_design_container_"+item.item_id.to_s
          class_on_dom_data_design_id_client = "img[data-design-id-client='#{user_items_design.items_design_id.to_s}']"
          class_on_dom_data_design_id_server = "img[data-design-id-server='#{user_items_design.items_design_id.to_s}']"
          class_on_dom_data_design_has_changed = "img[data-design-has-changed='false']"
          class_on_dom_data_room_clickable = "img[data-room-clickable='#{item.item.clickable}']"

          class_on_dom_data_room_hide = "img[data-room-hide='#{user_items_design.hide}']"
          class_on_dom_data_room_highlighted = "img[data-room-highlighted='false']"
          class_on_dom_data_design_item_id = "img[data-design-item-id ='#{item.item_id}']"
          class_on_dom_data_design_location_id = "img[data-design-location-id='#{user_items_design.location_id}']"


          find(@id_xroom_items_0).first(class_on_dom_room_design_container).find(class_on_dom_data_design_id_client).should be_visible
          find(@id_xroom_items_0).first(class_on_dom_room_design_container).find(class_on_dom_data_design_id_server).should be_visible
          find(@id_xroom_items_0).first(class_on_dom_room_design_container).find(class_on_dom_data_design_has_changed).should be_visible
          find(@id_xroom_items_0).first(class_on_dom_room_design_container).find(class_on_dom_data_room_clickable).should be_visible
          find(@id_xroom_items_0).first(class_on_dom_room_design_container).find(class_on_dom_data_room_hide).should be_visible
          find(@id_xroom_items_0).first(class_on_dom_room_design_container).find(class_on_dom_data_room_highlighted).should be_visible
          find(@id_xroom_items_0).first(class_on_dom_room_design_container).find(class_on_dom_data_design_item_id).should be_visible
          find(@id_xroom_items_0).first(class_on_dom_room_design_container).find(class_on_dom_data_design_location_id).should be_visible

          find(@id_xroom_items_1).first(class_on_dom_room_design_container).find(class_on_dom_data_design_id_client).should be_visible
          find(@id_xroom_items_1).first(class_on_dom_room_design_container).find(class_on_dom_data_design_id_server).should be_visible
          find(@id_xroom_items_1).first(class_on_dom_room_design_container).find(class_on_dom_data_design_has_changed).should be_visible
          find(@id_xroom_items_1).first(class_on_dom_room_design_container).find(class_on_dom_data_room_clickable).should be_visible
          find(@id_xroom_items_1).first(class_on_dom_room_design_container).find(class_on_dom_data_room_hide).should be_visible
          find(@id_xroom_items_1).first(class_on_dom_room_design_container).find(class_on_dom_data_room_highlighted).should be_visible
          find(@id_xroom_items_1).first(class_on_dom_room_design_container).find(class_on_dom_data_design_item_id).should be_visible
          find(@id_xroom_items_1).first(class_on_dom_room_design_container).find(class_on_dom_data_design_location_id).should be_visible

          find(@id_xroom_items_2).first(class_on_dom_room_design_container).find(class_on_dom_data_design_id_client).should be_visible
          find(@id_xroom_items_2).first(class_on_dom_room_design_container).find(class_on_dom_data_design_id_server).should be_visible
          find(@id_xroom_items_2).first(class_on_dom_room_design_container).find(class_on_dom_data_design_has_changed).should be_visible
          find(@id_xroom_items_2).first(class_on_dom_room_design_container).find(class_on_dom_data_room_clickable).should be_visible
          find(@id_xroom_items_2).first(class_on_dom_room_design_container).find(class_on_dom_data_room_hide).should be_visible
          find(@id_xroom_items_2).first(class_on_dom_room_design_container).find(class_on_dom_data_room_highlighted).should be_visible
          find(@id_xroom_items_2).first(class_on_dom_room_design_container).find(class_on_dom_data_design_item_id).should be_visible
          find(@id_xroom_items_2).first(class_on_dom_room_design_container).find(class_on_dom_data_design_location_id).should be_visible



          page.should have_css(class_on_dom_room_design_container, count: 3)
          page.should have_css(class_on_dom_data_design_id_client, count: 3)
          page.should have_css(class_on_dom_data_design_id_server, count: 3)
          page.should have_css(class_on_dom_data_design_item_id, count: 3)
          page.should have_css(class_on_dom_data_design_location_id, count: 3)

      end
  end

  end

  #***********************************
  # rspec test  test Theme is present
  #***********************************

  describe "background Theme present ", tag_dom_theme:true do
    before do
      @selector = ".current_background";
    end

    it "theme should be present " do

      puts @selector
      page.should have_selector(@selector)

    end

    it "theme should be three times" do
      page.should have_css(@selector, count: 3)
    end

    it "should have user theme" do
      user_theme = UsersTheme.find_by_user_id(@user.id)

      class_on_dom_data_theme_id_client = "img[data-theme-id-client='#{user_theme.theme_id}']"
      class_on_dom_data_theme_id_server = "img[data-theme-id-server='#{user_theme.theme_id}']"
      class_on_dom_data_section_id = "img[data-section-id='#{user_theme.section_id}']"
      class_on_dom_data_theme_has_changed = "img[data-theme-has-changed='false']"


      find(@id_xroom_items_0).find(class_on_dom_data_theme_id_client).should be_visible
      find(@id_xroom_items_0).find(class_on_dom_data_theme_id_server).should be_visible
      find(@id_xroom_items_0).find(class_on_dom_data_section_id).should be_visible
      find(@id_xroom_items_0).find(class_on_dom_data_theme_has_changed).should be_visible

      find(@id_xroom_items_1).find(class_on_dom_data_theme_id_client).should be_visible
      find(@id_xroom_items_1).find(class_on_dom_data_theme_id_server).should be_visible
      find(@id_xroom_items_1).find(class_on_dom_data_section_id).should be_visible
      find(@id_xroom_items_1).find(class_on_dom_data_theme_has_changed).should be_visible

      find(@id_xroom_items_2).find(class_on_dom_data_theme_id_client).should be_visible
      find(@id_xroom_items_2).find(class_on_dom_data_theme_id_server).should be_visible
      find(@id_xroom_items_2).find(class_on_dom_data_section_id).should be_visible
      find(@id_xroom_items_2).find(class_on_dom_data_theme_has_changed).should be_visible

      page.should have_css(class_on_dom_data_theme_id_client, count: 3)
      page.should have_css(class_on_dom_data_theme_id_server, count: 3)
      page.should have_css(class_on_dom_data_section_id, count: 3)
      page.should have_css(class_on_dom_data_theme_has_changed, count: 3)


    end


  end


end

