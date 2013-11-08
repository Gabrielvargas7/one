require 'spec_helper'

describe "tutorials/edit" do
  before(:each) do
    @tutorial = assign(:tutorial, stub_model(Tutorial,
      :name => "MyString",
      :image_name => "MyString",
      :description => "MyString",
      :step => 1
    ))
  end

  it "renders the edit tutorial form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", tutorial_path(@tutorial), "post" do
      assert_select "input#tutorial_name[name=?]", "tutorial[name]"
      assert_select "input#tutorial_image_name[name=?]", "tutorial[image_name]"
      assert_select "input#tutorial_description[name=?]", "tutorial[description]"
      assert_select "input#tutorial_step[name=?]", "tutorial[step]"
    end
  end
end
