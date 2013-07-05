require 'spec_helper'

describe UsersPhoto do
  # the (before) line will instance the variable for every (describe methods)
  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  before do
    @user = FactoryGirl.create(:user)
    @user_photos = FactoryGirl.create(:users_photo,user_id:@user.id)

  end

  #the (subject)line declare the variable that is use in all the test
  subject { @user_photos  }

  it { @user_photos.should respond_to(:user_id) }
  it { @user_photos.should respond_to(:description) }
  it { @user_photos.should respond_to(:profile_image) }

  it { @user_photos.should be_valid }


  ###############
  #test validation - default image
  ###############
  describe "when image default ", tag_image_default: true  do

    let(:image_default) {"/assets/fallback/users_photos/default_user.png"}

    it "should be default " do
      puts @user_photos.image_name
      @user_photos.image_name.to_s.should == image_default.to_s

    end

  end


  ###############
  #test validation - upload image
  ###############
  # these test only run when it is explicit.- example
  # bundle exec rspec --tag tag_image spec/models/theme_spec.rb
  describe "when image",tag_image_user_photos:true  do

    let(:user_with_image_upload) { UsersPhoto.create(
        description:"user test",
        image_name:Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'image', 'test_image.jpg'),
        user_id:@user.id,
        profile_image:'n'
        )
    )}

    it "should be upload to CDN - cloudinary " do
      puts user_with_image_upload.image_name
      user_with_image_upload.image_name.to_s.should include("http")
    end

  end

  ###############
  #test validation - profile image
  ###############
  describe "when profile image" , tag_profile_image: true  do
    context "is not present" do
      before {@user_photos.profile_image = " "}
      it {should_not be_valid}
    end

    context "must be 'yes' and lowercase" do
      before do
        @user_photos.profile_image = 'y'
      end
      it { 'y'.should == @user_photos.profile_image}
    end

    context "must be 'no' and lowercase" do
      before do
        @user_photos.profile_image = "n"
      end
      it { 'n'.should == @user_photos.profile_image}
    end



  end





end
