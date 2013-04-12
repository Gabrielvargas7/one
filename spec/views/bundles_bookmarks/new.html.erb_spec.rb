require 'spec_helper'

describe "bundles_bookmarks/new" do
  before(:each) do
    assign(:bundles_bookmark, stub_model(BundlesBookmark,
      :item_id => 1,
      :bookmark_id => 1
    ).as_new_record)
  end

  it "renders new bundles_bookmark form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => bundles_bookmarks_path, :method => "post" do
      assert_select "input#bundles_bookmark_item_id", :name => "bundles_bookmark[item_id]"
      assert_select "input#bundles_bookmark_bookmark_id", :name => "bundles_bookmark[bookmark_id]"
    end
  end
end
