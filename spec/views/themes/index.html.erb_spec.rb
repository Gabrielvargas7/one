require 'spec_helper'

describe "themes/index" do
  before(:each) do
    assign(:themes, [
      stub_model(Theme,
        :name => "Name",
        :description => "MyText",
        :image_name => "Image Name"
      ),
      stub_model(Theme,
        :name => "Name",
        :description => "MyText",
        :image_name => "Image Name"
      )
    ])
  end

  it "renders a list of themes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Image Name".to_s, :count => 2
  end
end
