require 'spec_helper'

describe "items_designs/show" do
  before(:each) do
    @items_design = assign(:items_design, stub_model(ItemsDesign,
      :name => "Name",
      :description => "MyText",
      :item_id => 1,
      :bundle_id => 2,
      :image_name => "Image Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/MyText/)
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/Image Name/)
  end
end
