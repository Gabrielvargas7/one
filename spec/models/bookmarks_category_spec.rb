# == Schema Information
#
# Table name: bookmarks_categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  item_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe BookmarksCategory do


  # the (before) line will instance the variable for every (describe methods)
  before do
    @item = @item = FactoryGirl.create(:item)
    @bookmarks_category = FactoryGirl.build(:bookmarks_category,item_id:@item.id)
  end


  #the (subject)line declare the variable that is use in all the test
  subject { @bookmarks_category }

  #theme info
  it { @bookmarks_category.should respond_to(:name) }
  it { @bookmarks_category.should respond_to(:item_id) }
  it { @bookmarks_category.should be_valid }

  ###############
  #test validation - name
  ###############
  describe "when the name" , tag_name: true  do

    context "is not present" do
      before {@bookmarks_category.name = " "}
      it {@bookmarks_category.should_not be_valid}
    end
  end

  ###############
  #test validation item id is present
  ###############
  describe " item_id ",tag_item_id:true do
    it "should be valid " do
      @bookmarks_category.item_id == @item.id
    end
  end

  ###############
  #test validation item id is not valid
  ###############

  describe "should not be valid item id ",tag_item_id:true do

    let(:bookmarks_category_not_item_id){BookmarksCategory.create(name:'bookmarks_category',item_id:-1)}
    it { bookmarks_category_not_item_id.should_not be_valid }

  end

  ###############
  #test methods validation - id_and_bookmark_category
  ###############
  describe "#id_and_bookmark_category",tag_id_and_bookmark_category:true do
    it "should be id_and_bookmark_category " do
      @bookmarks_category.id_and_bookmark_category == @bookmarks_category.id.to_s+"."+@bookmarks_category.name.to_s
    end
  end

  ###############
  #test function - id_and_bookmark_category
  ###############
  describe "when the function id_and_bookmark category" , tag_function: true  do

    context "get id and name" do
      before do

        @name = "bookmark category_name"
        @bookmarks_category.name = @name
        @bookmarks_category.save!


      end

      it "should print the id and name  " do
        #puts @bookmarks_category.id_and_bookmark_category
        @bookmarks_category.id_and_bookmark_category.should == "Item: #{@bookmarks_category.item_id}.#{@bookmarks_category.item.name} -> Bookmark Cat: #{@bookmarks_category.id}.#{@bookmarks_category.name}"

      end


    end
  end




end
