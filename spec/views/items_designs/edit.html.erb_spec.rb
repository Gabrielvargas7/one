require 'spec_helper'

describe "items_designs/edit" do
  before(:each) do
    @items_design = assign(:items_design, stub_model(ItemsDesign,
      :name => "MyString",
      :description => "MyText",
      :item_id => 1,
      :bundle_id => 1,
      :image_name => "MyString"
    ))
  end

  it "renders the edit items_design form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => items_designs_path(@items_design), :method => "post" do
      assert_select "input#items_design_name", :name => "items_design[name]"
      assert_select "textarea#items_design_description", :name => "items_design[description]"
      assert_select "input#items_design_item_id", :name => "items_design[item_id]"
      assert_select "input#items_design_bundle_id", :name => "items_design[bundle_id]"
      assert_select "input#items_design_image_name", :name => "items_design[image_name]"
    end
  end
end
