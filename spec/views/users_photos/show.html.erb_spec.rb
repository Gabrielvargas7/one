require 'spec_helper'

describe "users_photos/show" do
  before(:each) do
    @users_photo = assign(:users_photo, stub_model(UsersPhoto,
      :user_id => 1,
      :description => "Description",
      :image_name => "Image Name",
      :profile_image => "Profile Image"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Description/)
    rendered.should match(/Image Name/)
    rendered.should match(/Profile Image/)
  end
end
