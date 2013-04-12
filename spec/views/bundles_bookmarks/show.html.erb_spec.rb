require 'spec_helper'

describe "bundles_bookmarks/show" do
  before(:each) do
    @bundles_bookmark = assign(:bundles_bookmark, stub_model(BundlesBookmark,
      :item_id => 1,
      :bookmark_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
  end
end
