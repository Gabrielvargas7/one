require 'spec_helper'

describe "feedbacks/show" do
  before(:each) do
    @feedback = assign(:feedback, stub_model(Feedback,
      :description => "MyText",
      :user_id => 1,
      :name => "Name",
      :email => "Email"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    rendered.should match(/1/)
    rendered.should match(/Name/)
    rendered.should match(/Email/)
  end
end
