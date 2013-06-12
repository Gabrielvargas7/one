require 'spec_helper'

describe "items_locations/edit" do
  before(:each) do
    @items_location = assign(:items_location, stub_model(ItemsLocation,
      :item_id => 1,
      :location_id => 1
    ))
  end

  it "renders the edit items_location form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", items_location_path(@items_location), "post" do
      assert_select "input#items_location_item_id[name=?]", "items_location[item_id]"
      assert_select "input#items_location_location_id[name=?]", "items_location[location_id]"
    end
  end
end
