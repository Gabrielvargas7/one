require 'spec_helper'

describe "items/new" do
  before(:each) do
    assign(:item, stub_model(Item,
      :name => "MyString",
      :x => "9.99",
      :y => "9.99",
      :z => 1,
      :width => 1,
      :height => 1,
      :clickable => "MyString",
      :folder_name => "MyString"
    ).as_new_record)
  end

  it "renders new item form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => items_path, :method => "post" do
      assert_select "input#item_name", :name => "item[name]"
      assert_select "input#item_x", :name => "item[x]"
      assert_select "input#item_y", :name => "item[y]"
      assert_select "input#item_z", :name => "item[z]"
      assert_select "input#item_width", :name => "item[width]"
      assert_select "input#item_height", :name => "item[height]"
      assert_select "input#item_clickable", :name => "item[clickable]"
      assert_select "input#item_folder_name", :name => "item[folder_name]"
    end
  end
end
