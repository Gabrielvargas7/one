# == Schema Information
#
# Table name: notifications
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  image_name  :string(255)
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text
#  position    :integer
#

require 'spec_helper'

describe Notification do

  #:image_name, :name, :user_id,:description ,:position

  # the (before) line will instance the variable for every (describe methods)
  before {@notification = FactoryGirl.build(:notification)}

  #the (subject)line declare the variable that is use in all the test
  subject { @notification }

  #theme info
  it { @notification.should respond_to(:name) }
  it { @notification.should respond_to(:description) }
  it { @notification.should respond_to(:image_name)}
  it { @notification.should respond_to(:position) }
  it { @notification.should respond_to(:user_id) }
  it { @notification.should be_valid }


  ###############
  #test validation - upload image
  ###############
  # these test only run when it is explicit.- example
  # bundle exec rspec --tag tag_image spec/models/theme_spec.rb
  describe "when image",tag_image_notification:true  do

    let(:notification_with_image_upload) { Notification.create(
        name:"theme test",
        image_name:Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'image', 'test_image.jpg')),

    )}

    it "should be upload to CDN - cloudinary " do
      #puts notification_with_image_upload.image_name
      notification_with_image_upload.image_name.to_s.should include("http")

    end

  end

  ###############
  #test validation - default image
  ###############
  describe "when image default ", tag_image_default: true  do

    let(:image_default) {"/assets/fallback/notification/default_notification.png"}

    it "should be default  " do
      #puts @notification.image_name
      @notification.image_name.to_s.should == image_default.to_s

    end

  end

  ###############
  #test validation - name
  ###############
  describe "when the name" , tag_name: true  do

    context "is not present" do
      before {@notification.name = " "}
      it {should_not be_valid}
    end
  end



  ###############
  #test validation - position
  ###############
  describe "when the position" , tag_position: true  do

    context "is not present" do
      before {@notification.position = nil}
      it {should_not be_valid}
    end
    context " is not float '1.1' " do
      before {@notification.position = 1.1 }
      it {should_not be_valid}
    end
    context " is number and integer 1 " do
      before {@notification.position = 1 }
      it {should be_valid}
    end

  end


end
