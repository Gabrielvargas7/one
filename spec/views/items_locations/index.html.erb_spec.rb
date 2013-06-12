require 'spec_helper'

describe "items_locations/index" do
  before(:each) do
    assign(:items_locations, [
      stub_model(ItemsLocation,
        :item_id => 1,
        :location_id => 2
      ),
      stub_model(ItemsLocation,
        :item_id => 1,
        :location_id => 2
      )
    ])
  end

  it "renders a list of items_locations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
