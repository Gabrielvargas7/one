# == Schema Information
#
# Table name: bundles_items_designs
#
#  id              :integer          not null, primary key
#  items_design_id :integer
#  location_id     :integer
#  bundle_id       :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe BundlesItemsDesign do

  # the (before) line will instance the variable for every (describe methods)
  before do

    @section = FactoryGirl.create(:section)
    @theme = FactoryGirl.create(:theme)
    @bundle = FactoryGirl.create(:bundle,theme_id:@theme.id,section_id:@section.id)

    @location = FactoryGirl.create(:location,section_id:@section.id )
    @item = FactoryGirl.create(:item)
    @items_location = FactoryGirl.create(:items_location,location_id:@location.id,item_id:@item.id)
    @items_designs = FactoryGirl.create(:items_design,item_id:@item.id)
    @bundle_items_design = FactoryGirl.build(:bundles_items_design,bundle_id:@bundle.id,location_id:@items_location.location_id,items_design_id:@items_designs.id)

  end

  #the (subject)line declare the variable that is use in all the test
  subject { @bundle_items_design }

  #theme info
  it { @bundle_items_design.should respond_to(:bundle_id) }
  it { @bundle_items_design.should respond_to(:location_id) }
  it { @bundle_items_design.should respond_to(:items_design_id)}

  it { @bundle_items_design.should be_valid }



  ###############
  #test validation item design id and location id and bundle id is present
  ###############
  describe " ids ",tag_ids:true do
    it "should be valid " do
      @bundle_items_design.bundle_id = @bundle.id
      @bundle_items_design.items_design_id == @items_designs.id
      @bundle_items_design.location_id == @location.id

    end
  end

  ###############
  #test validation item design id and location id and bundle id  is not valid
  ###############

  describe "should not be valid ids ",tag_ids:true do

    let(:bundle_items_design_not_bundle_id){FactoryGirl.build(:bundles_items_design,bundle_id:-1,location_id:@items_location.location_id,items_design_id:@items_designs.id)}
    let(:bundle_items_design_not_location_id){FactoryGirl.build(:bundles_items_design,bundle_id:@bundle.id,location_id:-1,items_design_id:@items_designs.id)}
    let(:bundle_items_design_not_items_design_id){FactoryGirl.build(:bundles_items_design,bundle_id:@bundle.id,location_id:@items_location.location_id,items_design_id:-1)}


    it { bundle_items_design_not_items_design_id.should_not be_valid }
    it { bundle_items_design_not_location_id.should_not be_valid }
    it { bundle_items_design_not_items_design_id.should_not be_valid }


  end








end
