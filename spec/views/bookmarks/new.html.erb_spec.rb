require 'spec_helper'

describe "bookmarks/new" do
  before(:each) do
    assign(:bookmark, stub_model(Bookmark,
      :bookmarks_category_id => 1,
      :item_id => 1,
      :bookmark_url => "MyString",
      :title => "MyString",
      :i_frame => "MyString",
      :image_name => "MyString",
      :image_name_desc => "MyString",
      :description => "MyText"
    ).as_new_record)
  end

  it "renders new bookmark form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => bookmarks_path, :method => "post" do
      assert_select "input#bookmark_bookmarks_category_id", :name => "bookmark[bookmarks_category_id]"
      assert_select "input#bookmark_item_id", :name => "bookmark[item_id]"
      assert_select "input#bookmark_bookmark_url", :name => "bookmark[bookmark_url]"
      assert_select "input#bookmark_title", :name => "bookmark[title]"
      assert_select "input#bookmark_i_frame", :name => "bookmark[i_frame]"
      assert_select "input#bookmark_image_name", :name => "bookmark[image_name]"
      assert_select "input#bookmark_image_name_desc", :name => "bookmark[image_name_desc]"
      assert_select "textarea#bookmark_description", :name => "bookmark[description]"
    end
  end
end
