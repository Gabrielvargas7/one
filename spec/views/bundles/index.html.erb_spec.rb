require 'spec_helper'

describe "bundles/index" do
  before(:each) do
    assign(:bundles, [
      stub_model(Bundle,
        :name => "Name",
        :description => "MyText",
        :theme_id => 1,
        :image_name => "Image Name"
      ),
      stub_model(Bundle,
        :name => "Name",
        :description => "MyText",
        :theme_id => 1,
        :image_name => "Image Name"
      )
    ])
  end

  it "renders a list of bundles" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Image Name".to_s, :count => 2
  end
end
