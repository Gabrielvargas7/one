require 'spec_helper'

describe "static_contents/index" do
  before(:each) do
    assign(:static_contents, [
      stub_model(StaticContent,
        :name => "Name",
        :image_name => "Image Name",
        :description => "Description"
      ),
      stub_model(StaticContent,
        :name => "Name",
        :image_name => "Image Name",
        :description => "Description"
      )
    ])
  end

  it "renders a list of static_contents" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Image Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
