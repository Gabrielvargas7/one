require 'spec_helper'

describe "tutorials/show" do
  before(:each) do
    @tutorial = assign(:tutorial, stub_model(Tutorial,
      :name => "Name",
      :image_name => "Image Name",
      :description => "Description",
      :step => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Image Name/)
    rendered.should match(/Description/)
    rendered.should match(/1/)
  end
end
