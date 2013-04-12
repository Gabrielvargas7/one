require 'spec_helper'

describe "bundles_bookmarks/index" do
  before(:each) do
    assign(:bundles_bookmarks, [
      stub_model(BundlesBookmark,
        :item_id => 1,
        :bookmark_id => 2
      ),
      stub_model(BundlesBookmark,
        :item_id => 1,
        :bookmark_id => 2
      )
    ])
  end

  it "renders a list of bundles_bookmarks" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
