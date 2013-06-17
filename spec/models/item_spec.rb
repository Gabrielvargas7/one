# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  clickable   :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Item do

  #attr_accessible :clickable, :folder_name, :height, :name, :width, :x, :y, :z
  # the (before) line will instance the variable for every (describe methods)
  #before { @item = Item.new()}

  before {@item = FactoryGirl.build(:item) }


  #the (subject)line declare the variable that is use in all the test
  subject { @item }

  #theme info
  it { @item.should respond_to(:name) }
  it { @item.should respond_to(:clickable) }

  it { @item.should be_valid }


  ###############
  #test validation - name
  ###############
  describe "when the name" , tag_name: true  do

    context "is not present" do
      before {@item.name = " "}
      it {should_not be_valid}

    end
  end


  ###############
  #test validation - clickable
  ###############
  describe "when clickable" , tag_clickable: true  do
    context "is not present" do
      before {@item.clickable = " "}
      it {should_not be_valid}
    end

    context "must be 'yes' and lowercase" do
      before do
        @item.clickable = "yes"
      end
      it { 'yes'.should == @item.clickable}
    end

    context "must be 'no' and lowercase" do
      before do
        @item.clickable = "no"
      end
      it { 'no'.should == @item.clickable}
    end

    context "should not be 'ANYTHING' " do
      before do
        @item.clickable = "ANY"
      end
      it { 'no'.should_not == @item.clickable}
      it { 'yes'.should_not == @item.clickable}
    end

  end






end
