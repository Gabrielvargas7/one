require 'spec_helper'

describe "BookmarksCategories" do
  describe "GET /bookmarks_categories" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get bookmarks_categories_path
      response.status.should be(200)
    end
  end
end
