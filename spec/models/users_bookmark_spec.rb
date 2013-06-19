# == Schema Information
#
# Table name: users_bookmarks
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  bookmark_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  position    :integer
#

require 'spec_helper'

describe UsersBookmark do

  # the (before) line will instance the variable for every (describe methods)
  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  before do
    @user = FactoryGirl.create(:user)
    @item = FactoryGirl.create(:item)
    @bookmarks_category = FactoryGirl.create(:bookmarks_category,item_id:@item.id)
    @bookmark = FactoryGirl.create(:bookmark,item_id:@item.id,bookmarks_category_id:@bookmarks_category.id)
    @user_bookmark = FactoryGirl.build(:users_bookmark,user_id:@user.id,bookmark_id:@bookmark.id)

  end

  #the (subject)line declare the variable that is use in all the test
  subject { @user_bookmark }

  it { @user_bookmark.should respond_to(:bookmark_id) }
  it { @user_bookmark.should respond_to(:user_id) }
  it { @user_bookmark.should respond_to(:position) }

  it { @user_bookmark.should be_valid }



end
