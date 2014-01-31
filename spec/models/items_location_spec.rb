# == Schema Information
#
# Table name: items_locations
#
#  id          :integer          not null, primary key
#  item_id     :integer
#  location_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe ItemsLocation do


  #attr_accessible  :height, :name, :width, :x, :y, :z
  # the (before) line will instance the variable for every (describe methods)
  #before { @item = Item.new()}

  before do
    @section = FactoryGirl.create(:section)
    @location = FactoryGirl.create(:location,section_id:@section.id )
    @item = FactoryGirl.create(:item)
    @items_location = FactoryGirl.build(:items_location,location_id:@location.id,item_id:@item.id)
  end

  #the (subject)line declare the variable that is use in all the test
  subject { @items_location }

  #theme info
  it { @items_location.should respond_to(:item_id) }
  it { @items_location.should respond_to(:location_id) }


  it { @items_location.should be_valid }


  ###############
  #test validation item id and location id  is present
  ###############
  describe " item_id and location_id ",tag_item_id_location_id:true do
    it "should be valid " do
      @items_location.item_id == @item.id
      @items_location.location_id == @location.id

    end
  end

  ###############
  #test validation item id and location id  is not valid
  ###############

  describe "should not be valid item id and location id ",tag_item_id_location_id:true do

    let(:items_location_not_item_id){FactoryGirl.build(:items_location,location_id:@location.id,item_id:-1)}
    let(:items_location_not_location_id){FactoryGirl.build(:items_location,location_id:-1,item_id:@item_id)}

    it { items_location_not_item_id.should_not be_valid }
    it { items_location_not_location_id.should_not be_valid }

  end


  ###############
  #test function - item_location_section
  ###############
  describe "when the function id_and_location_section" , tag_function: true  do

    context "get id and location and section" do
      before do


        @location_name = @items_location.location.name
        @location_id = @items_location.location.id.to_s
        @section_id = @items_location.location.section_id.to_s
        @section_name = @items_location.location.section.name
        @item_id = @items_location.item_id.to_s
        @item_name = @items_location.item.name

      end

      it "should print the id and location and section " do

        #puts @items_location.item_location_section
        @items_location.item_location_section.should ==  "Item: "+@item_id+". "+@item_name+"  --Location:: "+@location_id.to_s+". "+@location_name+" --Section: "+@section_id.to_s+". "+@section_name


      end

    end
  end




end
