require 'spec_helper'

describe "themes/edit" do
  before(:each) do
    @theme = assign(:theme, stub_model(Theme,
      :name => "MyString",
      :description => "MyText",
      :image_name => "MyString"
    ))
  end

  it "renders the edit theme form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => themes_path(@theme), :method => "post" do
      assert_select "input#theme_name", :name => "theme[name]"
      assert_select "textarea#theme_description", :name => "theme[description]"
      assert_select "input#theme_image_name", :name => "theme[image_name]"
    end
  end
end
