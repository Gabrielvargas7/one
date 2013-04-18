require 'spec_helper'

describe "themes/show" do
  before(:each) do
    @theme = assign(:themes, stub_model(Theme,
      :name => "Name",
      :description => "MyText",
      :image_name => "Image Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/MyText/)
    rendered.should match(/Image Name/)
  end
end
