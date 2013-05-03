require 'spec_helper'

describe "feedbacks/edit" do
  before(:each) do
    @feedback = assign(:feedback, stub_model(Feedback,
      :description => "MyText",
      :user_id => 1,
      :name => "MyString",
      :email => "MyString"
    ))
  end

  it "renders the edit feedback form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", feedback_path(@feedback), "post" do
      assert_select "textarea#feedback_description[name=?]", "feedback[description]"
      assert_select "input#feedback_user_id[name=?]", "feedback[user_id]"
      assert_select "input#feedback_name[name=?]", "feedback[name]"
      assert_select "input#feedback_email[name=?]", "feedback[email]"
    end
  end
end
