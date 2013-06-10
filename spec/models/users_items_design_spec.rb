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

  before do
    @user = FactoryGirl.create(:user)
    @item = FactoryGirl.create(:item)
    @items_designs = FactoryGirl.create(:items_design,item_id:@item.id)

    @user_items_design = FactoryGirl.build(:users_items_design,user_id:@user.id,items_design_id:@items_designs.id)

  end

  #the (subject)line declare the variable that is use in all the test
  subject { @user_items_design }

  it { @user_items_design.should respond_to(:items_design_id) }
  it { @user_items_design.should respond_to(:user_id) }
  it { @user_items_design.should respond_to(:hide) }

  it { @user_items_design.should be_valid }




end
