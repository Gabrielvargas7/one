# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  clickable   :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Item do

  #attr_accessible :clickable, :folder_name, :height, :name, :width, :x, :y, :z
  # the (before) line will instance the variable for every (describe methods)
  #before { @item = Item.new()}

  before {@item = FactoryGirl.build(:item) }


  #the (subject)line declare the variable that is use in all the test
  subject { @item }

  #theme info
  it { @item.should respond_to(:name) }
  it { @item.should respond_to(:name_singular) }
  it { @item.should respond_to(:clickable) }
  it { @item.should respond_to(:priority_order) }
  it { @item.should respond_to(:image_name) }
  it { @item.should respond_to(:image_name_gray) }
  it { @item.should respond_to(:image_name_first_time_click) }



  it { @item.should be_valid }


  ###############
  #test validation - name
  ###############
  describe "when the name" , tag_name: true  do

    context "is not present" do
      before {@item.name = " "}
      it {should_not be_valid}

    end
  end

  describe "when the name_singular" , tag_name_singular: true  do

    context "is not present" do
      before {@item.name_singular = " "}
      it {should_not be_valid}

    end
  end


  ###############
  #test validation - clickable
  ###############
  describe "when clickable" , tag_clickable: true  do
    context "is not present" do
      before {@item.clickable = " "}
      it {should_not be_valid}
    end

    context "must be 'yes' and lowercase" do
      before do
        @item.clickable = "yes"
      end
      it { 'yes'.should == @item.clickable}
    end

    context "must be 'no' and lowercase" do
      before do
        @item.clickable = "no"
      end
      it { 'no'.should == @item.clickable}
    end

    context "should not be 'ANYTHING' " do
      before do
        @item.clickable = "ANY"
      end
      it { 'no'.should_not == @item.clickable}
      it { 'yes'.should_not == @item.clickable}
    end

  end


  ###############
  #test validation - upload image
  ###############
  # these test only run when it is explicit.- example
  # bundle exec rspec --tag tag_image spec/models/item_spec.rb
  describe "when image",tag_image_item:true  do

    let(:item_with_image_upload) { Item.create(
        name:"theme test",
        clickable:"yes",
        image_name:Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'image', 'test_image.jpg'))
    )}

    it "should be upload to CDN - cloudinary " do
      #puts theme_with_image_upload.image_name
      #puts theme_with_image_upload.image_name_selection
      item_with_image_upload.image_name.to_s.should include("http")


    end

  end


  ###############
  #test validation - default image
  ###############
  describe "when image default ", tag_image_default: true  do

    let(:image_default) {"/assets/fallback/item/default_item.png"}
    it "should be default  " do
      @item.image_name.to_s.should == image_default.to_s
    end

  end

  ###############
  #test validation - upload image gray
  ###############
  # these test only run when it is explicit.- example
  # bundle exec rspec --tag tag_image spec/models/item_spec.rb
  describe "when image gray",tag_image_gray_item:true  do

    let(:item_with_image_upload) { Item.create(
        name:"theme test",
        clickable:"yes",
        image_name_gray:Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'image', 'test_image.jpg'))
    )}

    it "should be upload to CDN - cloudinary " do
      #puts theme_with_image_upload.image_name
      #puts theme_with_image_upload.image_name_selection
      item_with_image_upload.image_name_gray.to_s.should include("http")


    end

  end


  ###############
  #test validation - default image  gray
  ###############
  describe "when image gray default ", tag_image_gray_default: true  do

    let(:image_gray_default) {"/assets/fallback/item/default_item.png"}
    it "should be default  " do
      @item.image_name_gray.to_s.should == image_gray_default.to_s
    end

  end


  ###############
  #test validation - upload image first time click
  ###############
  # these test only run when it is explicit.- example
  # bundle exec rspec --tag tag_image spec/models/item_spec.rb
  describe "when image first_time_click",tag_image_first_time_click_item:true  do

    let(:item_with_image_upload) { Item.create(
        name:"item test",
        clickable:"yes",
        image_name_first_time_click:Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'image', 'test_image.png'))
    )}

    it "should be upload to CDN - cloudinary " do
      puts item_with_image_upload.image_name_first_time_click.to_s
      item_with_image_upload.image_name_first_time_click.to_s.should include("http")

    end

  end


  ###############
  #test validation - default image first time click
  ###############
  describe "when image_name_first_time_click default ", tag_image_first_time_click_default: true  do

    let(:image_first_time_click_default) {"/assets/fallback/item/default_item.png"}
    it "should be default  " do
      @item.image_name_first_time_click.to_s.should == image_first_time_click_default.to_s
    end

  end



end
