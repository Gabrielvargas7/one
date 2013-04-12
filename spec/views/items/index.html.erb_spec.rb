require 'spec_helper'

describe "items/index" do
  before(:each) do
    assign(:items, [
      stub_model(Item,
        :name => "Name",
        :x => "9.99",
        :y => "9.99",
        :z => 1,
        :width => 2,
        :height => 3,
        :clickable => "Clickable",
        :folder_name => "Folder Name"
      ),
      stub_model(Item,
        :name => "Name",
        :x => "9.99",
        :y => "9.99",
        :z => 1,
        :width => 2,
        :height => 3,
        :clickable => "Clickable",
        :folder_name => "Folder Name"
      )
    ])
  end

  it "renders a list of items" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Clickable".to_s, :count => 2
    assert_select "tr>td", :text => "Folder Name".to_s, :count => 2
  end
end
