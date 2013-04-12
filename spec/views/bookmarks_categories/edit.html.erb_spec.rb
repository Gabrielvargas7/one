require 'spec_helper'

describe "bookmarks_categories/edit" do
  before(:each) do
    @bookmarks_category = assign(:bookmarks_category, stub_model(BookmarksCategory,
      :name => "MyString",
      :item_id => 1
    ))
  end

  it "renders the edit bookmarks_category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => bookmarks_categories_path(@bookmarks_category), :method => "post" do
      assert_select "input#bookmarks_category_name", :name => "bookmarks_category[name]"
      assert_select "input#bookmarks_category_item_id", :name => "bookmarks_category[item_id]"
    end
  end
end
