require 'spec_helper'

describe "static_contents/new" do
  before(:each) do
    assign(:static_content, stub_model(StaticContent,
      :name => "MyString",
      :image_name => "MyString",
      :description => "MyString"
    ).as_new_record)
  end

  it "renders new static_content form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", static_contents_path, "post" do
      assert_select "input#static_content_name[name=?]", "static_content[name]"
      assert_select "input#static_content_image_name[name=?]", "static_content[image_name]"
      assert_select "input#static_content_description[name=?]", "static_content[description]"
    end
  end
end
