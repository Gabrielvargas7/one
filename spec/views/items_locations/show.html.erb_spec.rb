require 'spec_helper'

describe "items_locations/show" do
  before(:each) do
    @items_location = assign(:items_location, stub_model(ItemsLocation,
      :item_id => 1,
      :location_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
  end
end
