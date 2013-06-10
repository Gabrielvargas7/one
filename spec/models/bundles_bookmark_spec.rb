# == Schema Information
#
# Table name: bundles_bookmarks
#
#  id          :integer          not null, primary key
#  item_id     :integer
#  bookmark_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe BundlesBookmark do


  # the (before) line will instance the variable for every (describe methods)
  before do
    @item = @item = FactoryGirl.create(:item)
    @bookmarks_category = FactoryGirl.create(:bookmarks_category,item_id:@item.id)
    @bookmark = FactoryGirl.create(:bookmark,item_id:@item.id,bookmarks_category_id:@bookmarks_category.id)
    @bundles_bookmark = FactoryGirl.build(:bundles_bookmark,item_id:@item.id,bookmark_id:@bookmark.id)

  end

  #the (subject)line declare the variable that is use in all the test
  subject { @bundles_bookmark }

  #theme info
  it { @bundles_bookmark.should respond_to(:bookmark_id) }
  it { @bundles_bookmark.should respond_to(:item_id) }

  it { @bundles_bookmark.should be_valid }


  ###############
  #test validation item id or bookmark id are present
  ###############
  describe " item_id ",tag_item_id:true do
    it "should be valid " do
      @bundles_bookmark.item_id == @item.id
      @bundles_bookmark.bookmark_id == @bookmark.id

    end
  end

  ##############
  #test validation item id is not valid
  ###############

  #describe "should not be valid item id ",tag_item_id:true do
  #
  #  #let(:bundles_bookmark_not_item_id){BookmarksCategory.new(item_id:-1,bookmark_id:@bookmark.id)}
  #  let(:bundles_bookmark_not_item_id){BookmarksCategory.new(item_id:-1,bookmark_id:-1)}
  #  it do
  #    put bundles_bookmark_not_item_id.item_id
  #    put bundles_bookmark_not_item_id.bookmark_id
  #    bundles_bookmark_not_item_id.should_not be_valid
  #  end
  #
  #
  #end

  ################
  ##test validation item id is not valid
  ################
  #
  #describe "should not be valid bookmark id ",tag_bookmark_id:true do
  #
  #  let(:bundles_bookmark_not_bookmark_id){BookmarksCategory.create(item_id:@item.id,bookmark_id:-1)}
  #  it { bundles_bookmark_not_bookmark_id.should_not be_valid }
  #
  #end



end
