require 'spec_helper'

describe "static_contents/edit" do
  before(:each) do
    @static_content = assign(:static_content, stub_model(StaticContent,
      :name => "MyString",
      :image_name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit static_content form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", static_content_path(@static_content), "post" do
      assert_select "input#static_content_name[name=?]", "static_content[name]"
      assert_select "input#static_content_image_name[name=?]", "static_content[image_name]"
      assert_select "input#static_content_description[name=?]", "static_content[description]"
    end
  end
end
