require 'spec_helper'

describe "static_contents/show" do
  before(:each) do
    @static_content = assign(:static_content, stub_model(StaticContent,
      :name => "Name",
      :image_name => "Image Name",
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Image Name/)
    rendered.should match(/Description/)
  end
end
