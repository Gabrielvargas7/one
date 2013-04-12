require 'spec_helper'

describe "items/show" do
  before(:each) do
    @item = assign(:item, stub_model(Item,
      :name => "Name",
      :x => "9.99",
      :y => "9.99",
      :z => 1,
      :width => 2,
      :height => 3,
      :clickable => "Clickable",
      :folder_name => "Folder Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/9.99/)
    rendered.should match(/9.99/)
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/Clickable/)
    rendered.should match(/Folder Name/)
  end
end
