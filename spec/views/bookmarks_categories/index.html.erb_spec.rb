require 'spec_helper'

describe "bookmarks_categories/index" do
  before(:each) do
    assign(:bookmarks_categories, [
      stub_model(BookmarksCategory,
        :name => "Name",
        :item_id => 1
      ),
      stub_model(BookmarksCategory,
        :name => "Name",
        :item_id => 1
      )
    ])
  end

  it "renders a list of bookmarks_categories" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
