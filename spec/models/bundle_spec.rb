# == Schema Information
#
# Table name: bundles
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  description            :text
#  theme_id               :integer
#  image_name             :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  image_name_set         :string(255)
#  section_id             :integer
#  active                 :string(255)      default("n")
#  category               :string(255)
#  style                  :string(255)
#  brand                  :string(255)
#  location               :string(255)
#  color                  :string(255)
#  make                   :string(255)
#  special_name           :string(255)
#  like                   :integer          default(0)
#  image_name_entire_room :string(255)
#

require 'spec_helper'

describe Bundle do

  #attr_accessible :description, :image_name, :name, :theme_id,:image_name_set

   # the (before) line will instance the variable for every (describe methods)
  before do
    @section = FactoryGirl.create(:section)
    @theme = FactoryGirl.create(:theme)
    @bundle = FactoryGirl.build(:bundle,theme_id:@theme.id,section_id:@section.id)

  end

  #the (subject)line declare the variable that is use in all the test
  subject { @bundle }

  #theme info
  it { @bundle.should respond_to(:name) }
  it { @bundle.should respond_to(:description) }
  it { @bundle.should respond_to(:image_name_set)}
  it { @bundle.should respond_to(:image_name_entire_room)}

  it { @bundle.should respond_to(:image_name)}
  it { @bundle.should respond_to(:theme_id) }
  it { @bundle.should respond_to(:section_id) }
  it { @bundle.should respond_to(:active) }
  it { @bundle.should respond_to(:special_name) }
  it { @bundle.should respond_to(:category) }
  it { @bundle.should respond_to(:style) }
  it { @bundle.should respond_to(:brand) }
  it { @bundle.should respond_to(:color) }
  it { @bundle.should respond_to(:location) }
  it { @bundle.should respond_to(:make) }
  it { @bundle.should respond_to(:like) }






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
      #puts bundle_with_image_upload.image_name
      #puts bundle_with_image_upload.image_name_set

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
      #puts @bundle.image_name
      #puts @bundle.image_name_set

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

    let(:bundle_not_theme_id){FactoryGirl.build(:bundle,theme_id:-1,section_id:@section.id)}
    it { bundle_not_theme_id.should_not be_valid }

  end

  ###############
  #test validation section_id on bundle
  ###############
  describe "bundle section_id ",tag_bundle_section_id:true do

    it "should be valid " do
      @bundle.section_id == @section.id
    end
  end

  ###############
  #test validation section_id on bundle
  ###############

  describe "should not be valid bundle section_id ",tag_bundle_section_id:true do

    let(:bundle_not_section_id){FactoryGirl.build(:bundle,theme_id:@theme.id,section_id:-1)}
    it { bundle_not_section_id.should_not be_valid }

  end

  ###############
  #test validation - active
  ###############
  describe "when active " , tag_active: true  do

    context "is not present" do
      before {@bundle.active = " "}
      it {should_not be_valid}
    end

    context "must be 'y' and lowercase" do
      before do
        @bundle.active = "y"
      end
      it { 'y'.should == @bundle.active}
    end

    context "must be 'n' and lowercase" do
      before do
        @bundle.active = "n"
      end
      it { 'n'.should == @bundle.active}
    end

    context "should not be 'ANYTHING' " do
      before do
        @bundle.active = "ANY"
      end
      it { 'n'.should_not == @bundle.active}
      it { 'y'.should_not == @bundle.active}
    end

  end




end
