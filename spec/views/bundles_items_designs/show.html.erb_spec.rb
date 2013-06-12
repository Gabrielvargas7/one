require 'spec_helper'

describe "bundles_items_designs/show" do
  before(:each) do
    @bundles_items_design = assign(:bundles_items_design, stub_model(BundlesItemsDesign,
      :items_design_id => 1,
      :location_id => 2,
      :bundle_id => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
  end
end
