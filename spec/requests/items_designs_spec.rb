require 'spec_helper'

describe "ItemsDesigns" do
  describe "GET /items_designs" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get items_designs_path
      response.status.should be(200)
    end
  end
end
