require 'spec_helper'

describe "users_photos/index" do
  before(:each) do
    assign(:users_photos, [
      stub_model(UsersPhoto,
        :user_id => 1,
        :description => "Description",
        :image_name => "Image Name",
        :profile_image => "Profile Image"
      ),
      stub_model(UsersPhoto,
        :user_id => 1,
        :description => "Description",
        :image_name => "Image Name",
        :profile_image => "Profile Image"
      )
    ])
  end

  it "renders a list of users_photos" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Image Name".to_s, :count => 2
    assert_select "tr>td", :text => "Profile Image".to_s, :count => 2
  end
end
