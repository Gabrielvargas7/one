# == Schema Information
#
# Table name: users_items_designs
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  items_design_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  hide            :string(255)
#

require 'spec_helper'

describe UsersItemsDesign do

  before(:all){ create_init_data }
  after(:all){ delete_init_data }


  before do
    @user = FactoryGirl.create(:user)
    @section = FactoryGirl.create(:section)
    @location = FactoryGirl.create(:location,section_id:@section.id )
    @item = FactoryGirl.create(:item)
    @items_location = FactoryGirl.create(:items_location,location_id:@location.id,item_id:@item.id)
    @items_designs = FactoryGirl.create(:items_design,item_id:@item.id)
    @user_items_design = FactoryGirl.build(:users_items_design,user_id:@user.id,items_design_id:@items_designs.id,location_id:@items_location.location_id)

  end

  #the (subject)line declare the variable that is use in all the test
  subject { @user_items_design }

  it { @user_items_design.should respond_to(:items_design_id) }
  it { @user_items_design.should respond_to(:user_id) }
  it { @user_items_design.should respond_to(:hide) }
  it { @user_items_design.should respond_to(:location_id) }


  it { @user_items_design.should be_valid }

###############
#test validation location is present
###############
  describe " id location id ",tag_location_id:true do
    it "should be valid " do
      @user_items_design.location_id = @location.id
    end
  end

  ###############
  #test validation location id is not valid
  ###############

  describe "should not be valid ids ",tag_location_id:true do

    let(:users_items_design_not_location_id){FactoryGirl.build(:users_items_design,user_id:@user.id,items_design_id:@items_designs.id,location_id:-1)}
    let(:users_items_design_not_items_design_id){FactoryGirl.build(:users_items_design,user_id:@user.id,items_design_id:-1,location_id:@items_location.location_id)}

    it { users_items_design_not_location_id.should_not be_valid }
    it { users_items_design_not_items_design_id.should_not be_valid }




  end




end
