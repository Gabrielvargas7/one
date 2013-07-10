# == Schema Information
#
# Table name: themes
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  description          :text
#  image_name           :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  image_name_selection :string(255)
#

require 'spec_helper'

describe Theme do

  # the (before) line will instance the variable for every (describe methods)
  before {@theme = FactoryGirl.build(:theme)}


  #the (subject)line declare the variable that is use in all the test
  subject { @theme }

  #theme info
  it { @theme.should respond_to(:name) }
  it { @theme.should respond_to(:description) }
  it { @theme.should respond_to(:image_name_selection)}
  it { @theme.should respond_to(:image_name)}
  it { @theme.should respond_to(:image_name_cache) }
  it { @theme.should respond_to(:image_name_selection_cache) }

  it { @theme.should be_valid }


  ###############
  #test validation - upload image
  ###############
  # these test only run when it is explicit.- example
  # bundle exec rspec --tag tag_image spec/models/theme_spec.rb
  describe "when image",tag_image_theme:true  do

        let(:theme_with_image_upload) { Theme.create(
                    name:"theme test",
                    image_name:Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'image', 'test_image.jpg')),
                    image_name_selection:Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'image', 'test_image.jpg'))
        )}

        it "should be upload to CDN - cloudinary " do
           #puts theme_with_image_upload.image_name
           #puts theme_with_image_upload.image_name_selection

           theme_with_image_upload.image_name.to_s.should include("http")
           theme_with_image_upload.image_name_selection.to_s.should include("http")

        end

  end


  ###############
  #test validation - default image
  ###############
  describe "when image default ", tag_image_default: true  do

    let(:image_default) {"/assets/fallback/theme/default_theme.png"}

    it "should be default  " do
      #puts @theme.image_name
      #puts @theme.image_name_selection

      @theme.image_name.to_s.should == image_default.to_s
      @theme.image_name_selection.to_s.should == image_default.to_s
    end

  end


  ###############
  #test validation - name
  ###############
  describe "when the name" , tag_name: true  do

    context "is not present" do
      before {@theme.name = " "}
      it {should_not be_valid}

    end
  end

  ###############
  #test methods validation - id.name
  ###############
  describe "#id_and_theme",tag_id_and_theme:true do
    it "should be id and theme " do
      @theme.id_and_theme == @theme.id.to_s+"."+@theme.name.to_s
    end
  end







end
