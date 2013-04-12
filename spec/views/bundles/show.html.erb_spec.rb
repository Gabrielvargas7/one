require 'spec_helper'

describe "bundles/show" do
  before(:each) do
    @bundle = assign(:bundle, stub_model(Bundle,
      :name => "Name",
      :description => "MyText",
      :theme_id => 1,
      :image_name => "Image Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/MyText/)
    rendered.should match(/1/)
    rendered.should match(/Image Name/)
  end
end
