require 'spec_helper'

describe "bundles_bookmarks/edit" do
  before(:each) do
    @bundles_bookmark = assign(:bundles_bookmark, stub_model(BundlesBookmark,
      :item_id => 1,
      :bookmark_id => 1
    ))
  end

  it "renders the edit bundles_bookmark form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => bundles_bookmarks_path(@bundles_bookmark), :method => "post" do
      assert_select "input#bundles_bookmark_item_id", :name => "bundles_bookmark[item_id]"
      assert_select "input#bundles_bookmark_bookmark_id", :name => "bundles_bookmark[bookmark_id]"
    end
  end
end
