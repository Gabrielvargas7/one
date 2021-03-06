require 'spec_helper'

describe "bundles_items_designs/edit" do
  before(:each) do
    @bundles_items_design = assign(:bundles_items_design, stub_model(BundlesItemsDesign,
      :items_design_id => 1,
      :location_id => 1,
      :bundle_id => 1
    ))
  end

  it "renders the edit bundles_items_design form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", bundles_items_design_path(@bundles_items_design), "post" do
      assert_select "input#bundles_items_design_items_design_id[name=?]", "bundles_items_design[items_design_id]"
      assert_select "input#bundles_items_design_location_id[name=?]", "bundles_items_design[location_id]"
      assert_select "input#bundles_items_design_bundle_id[name=?]", "bundles_items_design[bundle_id]"
    end
  end
end
