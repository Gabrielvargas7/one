# == Schema Information
#
# Table name: bundles
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  description    :text
#  theme_id       :integer
#  image_name     :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  image_name_set :string(255)
#

require 'spec_helper'

describe Bundle do

  #attr_accessible :description, :image_name, :name, :theme_id,:image_name_set

   # the (before) line will instance the variable for every (describe methods)
  before do
    @theme = FactoryGirl.create(:theme)
    @bundle = FactoryGirl.build(:bundle,theme_id:@theme.id)

  end

  #the (subject)line declare the variable that is use in all the test
  subject { @bundle }

  #theme info
  it { @bundle.should respond_to(:name) }
  it { @bundle.should respond_to(:description) }
  it { @bundle.should respond_to(:image_name_set)}
  it { @bundle.should respond_to(:image_name)}
  it { @bundle.should respond_to(:theme_id) }

  it { @bundle.should be_valid }


  ###############
  #test validation - upload image
  ###############
  # these test only run when it is explicit.- example
  # bundle exec rspec --tag tag_image spec/models/<name>_spec.rb
  describe "when image",tag_image_bundle:true  do

    let(:bundle_with_image_upload) { Bundle.create(
        name:"bundle test",
        image_name:Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'image', 'test_image.jpg')),
        image_name_set:Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'image', 'test_image.jpg'))
    )}

    it "should be upload to CDN - cloudinary " do
      puts bundle_with_image_upload.image_name
      puts bundle_with_image_upload.image_name_set

      bundle_with_image_upload.image_name.to_s.should include("http")
      bundle_with_image_upload.image_name_set.to_s.should include("http")

    end

  end


  ###############
  #test validation - default image
  ###############
  describe "when image default ", tag_image_default: true  do

    let(:image_default) {"/assets/fallback/bundle/default_bundle.png"}

    it "should be default  " do
      puts @bundle.image_name
      puts @bundle.image_name_set

      @bundle.image_name.to_s.should == image_default.to_s
      @bundle.image_name_set.to_s.should == image_default.to_s
    end

  end


  ###############
  #test validation - name
  ###############
  describe "when the name" , tag_name: true  do

    context "is not present" do
      before {@bundle.name = " "}
      it {should_not be_valid}

    end
  end

  ###############
  #test validation theme_id on bundle
  ###############
  describe "bundle theme_id ",tag_bundle_theme_id:true do

    it "should be valid " do

      @bundle.theme_id == @theme.id
    end
  end

  ###############
  #test validation theme_id on bundle
  ###############

  describe "should not be valid bundle theme_id ",tag_bundle_theme_id:true do

    let(:bundle_not_theme_id){Bundle.create(name:'bundle',theme_id:-1)}
    it { bundle_not_theme_id.should_not be_valid }

  end





end
