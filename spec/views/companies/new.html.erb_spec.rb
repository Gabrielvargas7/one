require 'spec_helper'

describe "companies/new" do
  before(:each) do
    assign(:company, stub_model(Company,
      :name => "MyString",
      :image_name => "MyString",
      :description => "MyString"
    ).as_new_record)
  end

  it "renders new company form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", companies_path, "post" do
      assert_select "input#company_name[name=?]", "company[name]"
      assert_select "input#company_image_name[name=?]", "company[image_name]"
      assert_select "input#company_description[name=?]", "company[description]"
    end
  end
end
