# FAILING SPEC

# require 'spec_helper'

# describe "items_locations/new" do
#   before(:each) do
#     assign(:items_location, stub_model(ItemsLocation,
#       :item_id => 1,
#       :location_id => 1
#     ).as_new_record)
#   end

#   it "renders new items_location form" do
#     render

#     # Run the generator again with the --webrat flag if you want to use webrat matchers
#     assert_select "form[action=?][method=?]", items_locations_path, "post" do
#       assert_select "input#items_location_item_id[name=?]", "items_location[item_id]"
#       assert_select "input#items_location_location_id[name=?]", "items_location[location_id]"
#     end
#   end
# end
