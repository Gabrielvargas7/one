require 'spec_helper'

describe "users_profiles/new" do
  before(:each) do
    assign(:users_profile, stub_model(UsersProfile,
      :firstname => "MyString",
      :lastname => "MyString",
      :gender => "MyString",
      :description => "MyString",
      :city => "MyString",
      :country => "MyString",
      :user_id => 1
    ).as_new_record)
  end

  it "renders new users_profile form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", users_profiles_path, "post" do
      assert_select "input#users_profile_firstname[name=?]", "users_profile[firstname]"
      assert_select "input#users_profile_lastname[name=?]", "users_profile[lastname]"
      assert_select "input#users_profile_gender[name=?]", "users_profile[gender]"
      assert_select "input#users_profile_description[name=?]", "users_profile[description]"
      assert_select "input#users_profile_city[name=?]", "users_profile[city]"
      assert_select "input#users_profile_country[name=?]", "users_profile[country]"
      assert_select "input#users_profile_user_id[name=?]", "users_profile[user_id]"
    end
  end
end
