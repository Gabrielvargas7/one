require 'spec_helper'

describe "users_profiles/index" do
  before(:each) do
    assign(:users_profiles, [
      stub_model(UsersProfile,
        :firstname => "Firstname",
        :lastname => "Lastname",
        :gender => "Gender",
        :description => "Description",
        :city => "City",
        :country => "Country",
        :user_id => 1
      ),
      stub_model(UsersProfile,
        :firstname => "Firstname",
        :lastname => "Lastname",
        :gender => "Gender",
        :description => "Description",
        :city => "City",
        :country => "Country",
        :user_id => 1
      )
    ])
  end

  it "renders a list of users_profiles" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Firstname".to_s, :count => 2
    assert_select "tr>td", :text => "Lastname".to_s, :count => 2
    assert_select "tr>td", :text => "Gender".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "City".to_s, :count => 2
    assert_select "tr>td", :text => "Country".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
