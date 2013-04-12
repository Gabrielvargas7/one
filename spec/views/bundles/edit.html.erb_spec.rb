require 'spec_helper'

describe "bundles/edit" do
  before(:each) do
    @bundle = assign(:bundle, stub_model(Bundle,
      :name => "MyString",
      :description => "MyText",
      :theme_id => 1,
      :image_name => "MyString"
    ))
  end

  it "renders the edit bundle form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => bundles_path(@bundle), :method => "post" do
      assert_select "input#bundle_name", :name => "bundle[name]"
      assert_select "textarea#bundle_description", :name => "bundle[description]"
      assert_select "input#bundle_theme_id", :name => "bundle[theme_id]"
      assert_select "input#bundle_image_name", :name => "bundle[image_name]"
    end
  end
end
