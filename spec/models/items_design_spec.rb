# == Schema Information
#
# Table name: items_designs
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  description          :text
#  item_id              :integer
#  image_name           :string(255)
#  image_name_hover     :string(255)
#  image_name_selection :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

require 'spec_helper'

describe ItemsDesign do

  #attr_accessible : :description, :image_name, :item_id, :name,:image_name_hover,:image_name_selection

  # the (before) line will instance the variable for every (describe methods)
  before do
      @item = FactoryGirl.create(:item)
      @items_designs = FactoryGirl.build(:items_design,item_id:@item.id)
  end

  #the (subject)line declare the variable that is use in all the test
  subject { @items_designs }

  #theme info
  it { @items_designs.should respond_to(:name) }
  it { @items_designs.should respond_to(:description) }
  it { @items_designs.should respond_to(:image_name_hover)}
  it { @items_designs.should respond_to(:image_name_selection)}
  it { @items_designs.should respond_to(:image_name)}
  it { @items_designs.should respond_to(:image_name_logo)}

  it { @items_designs.should respond_to(:item_id) }
  it { @items_designs.should respond_to(:special_name) }
  it { @items_designs.should respond_to(:category) }
  it { @items_designs.should respond_to(:style) }
  it { @items_designs.should respond_to(:brand) }
  it { @items_designs.should respond_to(:color) }
  it { @items_designs.should respond_to(:make) }
  it { @items_designs.should respond_to(:like) }
  it { @items_designs.should respond_to(:price) }
  it { @items_designs.should respond_to(:product_url) }




  it { @items_designs.should be_valid }


  ###############
  #test validation - name
  ###############
  describe "when the name" , tag_name: true  do

    context "is not present" do
      before {@items_designs.name = " "}
      it {@items_designs.should_not be_valid}
    end
  end

  ###############
  #test validation item id is present
  ###############
  describe " item_id ",tag_item_id:true do
    it "should be valid " do
      @items_designs.item_id == @item.id
    end
  end

  ###############
  #test validation item id is not valid
  ###############

  describe "should not be valid item id ",tag_item_id:true do

    let(:items_design_not_item_id){ItemsDesign.create(name:'item design',item_id:-1)}
    it { items_design_not_item_id.should_not be_valid }

  end


  ###############
  #test validation - upload image
  ###############
  # these test only run when it is explicit.- example
  # bundle exec rspec --tag tag_image spec/models/<name>_spec.rb
  describe "when image", tag_image_items_design:true  do

    let(:items_design_with_image_upload) {ItemsDesign.create(
        name:"items_design test",
        image_name:Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'image', 'test_image.jpg')),
        image_name_hover:Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'image', 'test_image.jpg')),
        image_name_selection:Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'image', 'test_image.jpg')))
    }

    it "should be upload to CDN - cloudinary " do

      #puts items_design_with_image_upload.image_name
      #puts items_design_with_image_upload.image_name_hover
      #puts items_design_with_image_upload.image_name_selection

      items_design_with_image_upload.image_name.to_s.should include("http")
      items_design_with_image_upload.image_name_hover.to_s.should include("http")
      items_design_with_image_upload.image_name_selection.to_s.should include("http")

    end

  end


  ###############
  #test validation - default image
  ###############
  describe "when image default ", tag_image_default: true  do

    let(:image_default) {"/assets/fallback/items_design/default_items_design.png"}

    it "should be default  " do
      #puts @items_designs.image_name
      #puts @items_designs.image_name_hover
      #puts @items_designs.image_name_selection


      @items_designs.image_name.to_s.should == image_default.to_s
      @items_designs.image_name_hover.to_s.should == image_default.to_s
      @items_designs.image_name_selection.to_s.should == image_default.to_s

    end

  end




end
