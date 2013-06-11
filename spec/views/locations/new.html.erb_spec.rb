require 'spec_helper'

describe "locations/new" do
  before(:each) do
    assign(:location, stub_model(Location,
      :name => "MyString",
      :description => "MyString",
      :x => "9.99",
      :y => "9.99",
      :z => 1,
      :width => 1,
      :height => 1,
      :section_id => 1
    ).as_new_record)
  end

  it "renders new location form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", locations_path, "post" do
      assert_select "input#location_name[name=?]", "location[name]"
      assert_select "input#location_description[name=?]", "location[description]"
      assert_select "input#location_x[name=?]", "location[x]"
      assert_select "input#location_y[name=?]", "location[y]"
      assert_select "input#location_z[name=?]", "location[z]"
      assert_select "input#location_width[name=?]", "location[width]"
      assert_select "input#location_height[name=?]", "location[height]"
      assert_select "input#location_section_id[name=?]", "location[section_id]"
    end
  end
end
