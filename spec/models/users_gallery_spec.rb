# == Schema Information
#
# Table name: users_galleries
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  image_name :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe UsersGallery do

  # the (before) line will instance the variable for every (describe methods)
  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  before do

    @user = FactoryGirl.create(:user)
    @user_gallery = UsersGallery.new(user_id:@user.id)
  end


  #the (subject)line declare the variable that is use in all the test
  subject { @user_gallery }

  #theme info
  it { @user_gallery.should respond_to(:user_id) }
  it { @user_gallery.should respond_to(:image_name) }

  it { @user_gallery.should be_valid }



  ###############
  #test validation - upload image
  ###############
  # these test only run when it is explicit.- example
  # bundle exec rspec --tag tag_image spec/models/theme_spec.rb
  describe "when image",tag_image_user_gallery:true  do

    let(:user_gallery_with_image_upload) { UsersGallery.create(
        user_id:@user.id,
        image_name:Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'image', 'test_image.jpg'))
    )}

    it "should be upload to CDN - cloudinary " do
      puts user_gallery_with_image_upload.image_name
      user_gallery_with_image_upload.image_name.to_s.should include("http")
    end

  end


  ###############
  #test validation - default image
  ###############
  describe "when image default ", tag_image_default: true  do

    let(:image_default) {"/assets/fallback/users_gallery/default_user.png"}

    it "should be default  " do
      puts @user_gallery.image_name
      @user_gallery.image_name.to_s.should == image_default.to_s

    end

  end




end
