require 'spec_helper'

describe "bookmarks_categories/show" do
  before(:each) do
    @bookmarks_category = assign(:bookmarks_category, stub_model(BookmarksCategory,
      :name => "Name",
      :item_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/1/)
  end
end
