require 'spec_helper'

describe "users_photos/edit" do
  before(:each) do
    @users_photo = assign(:users_photo, stub_model(UsersPhoto,
      :user_id => 1,
      :description => "MyString",
      :image_name => "MyString",
      :profile_image => "MyString"
    ))
  end

  it "renders the edit users_photo form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", users_photo_path(@users_photo), "post" do
      assert_select "input#users_photo_user_id[name=?]", "users_photo[user_id]"
      assert_select "input#users_photo_description[name=?]", "users_photo[description]"
      assert_select "input#users_photo_image_name[name=?]", "users_photo[image_name]"
      assert_select "input#users_photo_profile_image[name=?]", "users_photo[profile_image]"
    end
  end
end
