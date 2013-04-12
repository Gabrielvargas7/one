require 'spec_helper'

describe "bookmarks/show" do
  before(:each) do
    @bookmark = assign(:bookmark, stub_model(Bookmark,
      :bookmarks_category_id => 1,
      :item_id => 2,
      :bookmark_url => "Bookmark Url",
      :title => "Title",
      :i_frame => "I Frame",
      :image_name => "Image Name",
      :image_name_desc => "Image Name Desc",
      :description => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/Bookmark Url/)
    rendered.should match(/Title/)
    rendered.should match(/I Frame/)
    rendered.should match(/Image Name/)
    rendered.should match(/Image Name Desc/)
    rendered.should match(/MyText/)
  end
end
