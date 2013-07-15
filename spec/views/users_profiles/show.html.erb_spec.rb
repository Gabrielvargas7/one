require 'spec_helper'

describe "users_profiles/show" do
  before(:each) do
    @users_profile = assign(:users_profile, stub_model(UsersProfile,
      :firstname => "Firstname",
      :lastname => "Lastname",
      :gender => "Gender",
      :description => "Description",
      :city => "City",
      :country => "Country",
      :user_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Firstname/)
    rendered.should match(/Lastname/)
    rendered.should match(/Gender/)
    rendered.should match(/Description/)
    rendered.should match(/City/)
    rendered.should match(/Country/)
    rendered.should match(/1/)
  end
end
