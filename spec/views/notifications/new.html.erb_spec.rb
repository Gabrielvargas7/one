require 'spec_helper'

describe "notifications/new" do
  before(:each) do
    assign(:notification, stub_model(Notification,
      :name => "MyString",
      :image_name => "MyString",
      :user_id => 1
    ).as_new_record)
  end

  it "renders new notification form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", notifications_path, "post" do
      assert_select "input#notification_name[name=?]", "notification[name]"
      assert_select "input#notification_image_name[name=?]", "notification[image_name]"
      assert_select "input#notification_user_id[name=?]", "notification[user_id]"
    end
  end
end
