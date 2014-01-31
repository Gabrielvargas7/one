# == Schema Information
#
# Table name: bookmarks
#
#  id                    :integer          not null, primary key
#  bookmarks_category_id :integer
#  bookmark_url          :text
#  title                 :string(255)
#  i_frame               :string(255)      default("y")
#  image_name            :string(255)
#  image_name_desc       :string(255)
#  description           :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  approval              :string(255)      default("y")
#  user_bookmark         :integer          default(0)
#  like                  :integer          default(0)
#

require 'spec_helper'

describe Bookmark do

  before do
    @item = FactoryGirl.create(:item)
    @bookmarks_category = FactoryGirl.create(:bookmarks_category,item_id:@item.id)
    #@bookmark = FactoryGirl.build(:bookmark,item_id:@item.id,bookmarks_category_id:@bookmarks_category.id)
    @bookmark = FactoryGirl.build(:bookmark,bookmarks_category_id:@bookmarks_category.id)

  end


  #the (subject)line declare the variable that is use in all the test
  subject { @bookmark }

  #theme info
  it { @bookmark.should respond_to(:title) }
  it { @bookmark.should respond_to(:description) }
  it { @bookmark.should respond_to(:image_name)}
  it { @bookmark.should respond_to(:image_name_desc)}
  it { @bookmark.should respond_to(:i_frame) }
  it { @bookmark.should respond_to(:bookmarks_category_id) }
  #it { @bookmark.should respond_to(:item_id) }
  it { @bookmark.should respond_to(:approval) }
  it { @bookmark.should respond_to(:user_bookmark) }
  it { @bookmark.should respond_to(:like) }
  it { @bookmark.should respond_to(:bookmark_url) }
  it { @bookmark.should respond_to(:remote_image_name_url)}
  it { @bookmark.should respond_to(:remote_image_name_desc_url)}

  #it { @bookmark.should belong_to(:bookmarks_category)}



  it { @bookmark.should be_valid }

  ###############
  #test validation - upload image
  ###############
  # these test only run when it is explicit.- example
  # bundle exec rspec --tag tag_image spec/models/<name>_spec.rb
  describe "when image",tag_image_bookmark:true  do

    let(:bookmark_with_image_upload) { Bookmark.create(
        title:"Bookmark test",
        image_name:Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'image', 'test_image.jpg')),
        image_name_desc:Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'image', 'test_image.jpg'))
    )}

    it "should be upload to CDN - cloudinary " do
      #puts bookmark_with_image_upload.image_name
      #puts bookmark_with_image_upload.image_name_desc

      bookmark_with_image_upload.image_name.to_s.should include("http")
      bookmark_with_image_upload.image_name_desc.to_s.should include("http")

    end

  end


  ###############
  #test validation - default image
  ###############
  describe "when image default ", tag_image_default: true  do

    let(:image_default) {"/assets/fallback/bookmark/default_bookmark.png"}

    it "should be default  " do
      #puts @bookmark.image_name
      #puts @bookmark.image_name_desc

      @bookmark.image_name.to_s.should == image_default.to_s
      @bookmark.image_name_desc.to_s.should == image_default.to_s
    end

  end


  ###############
  #test validation - name
  ###############
  describe "when the title" , tag_title: true  do

    context "is not present" do
      before {@bookmark.title = " "}
      it {should_not be_valid}

    end

    context "has over 100 characters" do
      before{@bookmark.title = "Fetch the toy, Roomsy! Fetch the toy, Roomsy! Fetch the toy, Roomsy! Fetch the toy, Roomsy! Fetch the toy, Roomsy! "}
      it {should_not be_valid}    
    end
  end


  ###############
  #test validation item_id on bookmark
  ###############
  describe "bookmarks_category_id on bookmark",tag_bookmarks_category_id_on_bookmark:true do

    it "should be valid " do
      @bookmark.bookmarks_category_id == @bookmarks_category.id
    end
    context "is not valid if its a string" do
      before{@bookmark.bookmarks_category_id = "Roomsy"}
      it {should_not be_valid}
    end
    context "is not valid if its not an integer" do
      before{@bookmark.bookmarks_category_id = 22.4}
      it {should_not be_valid}
    end

  end

  ###############
  #test validation - i_frame
  ###############
  describe "when i_frame " , tag_i_frame: true  do

      context "is not present" do
        before {@bookmark.i_frame = " "}
        it {should_not be_valid}
      end

      context "must be 'y' and lowercase" do
        before do
          @bookmark.i_frame = "y"
        end
        it { 'y'.should == @bookmark.i_frame}
      end

      context "must be 'n' and lowercase" do
        before do
          @bookmark.i_frame = "n"
        end
        it { 'n'.should == @bookmark.i_frame}
      end

      context "should not be 'ANYTHING' " do
        before do
          @bookmark.i_frame = "ANY"
        end
        it { 'n'.should_not == @bookmark.i_frame}
        it { 'y'.should_not == @bookmark.i_frame}
      end

  end


  ###############
  #test validation - bookmark url
  ###############
  describe "when bookmark_url " , tag_bookmark_url: true  do

    context "is not present" do
      before {@bookmark.bookmark_url = " "}
      it {should_not be_valid}
    end

    context "must start 'http" do
      before do
        @bookmark.bookmark_url = "http"
      end
      it { 'http'.should == @bookmark.bookmark_url}
    end


    context "should not be 'ANYTHING' " do
      before do
        @bookmark.bookmark_url = "ANY"
      end
      it { "http".should_not == @bookmark.bookmark_url}

    end
  end


  ###############
  #test validation - approval
  ###############
  describe "when approval " , tag_approval: true  do

    context "is not present" do
      before {@bookmark.approval = " "}
      it {should_not be_valid}
    end

    context "must be 'y' and lowercase" do
      before do
        @bookmark.approval = "y"
      end
      it { 'y'.should == @bookmark.approval}
    end

    context "must be 'n' and lowercase" do
      before do
        @bookmark.approval = "n"
      end
      it { 'n'.should == @bookmark.approval}
    end

    context "should not be 'ANYTHING' " do
      before do
        @bookmark.approval = "ANY"
      end
      it { 'n'.should_not == @bookmark.approval}
      it { 'y'.should_not == @bookmark.approval}
    end

  end


  ###############
  #test methods validation - id_and_bookmark
  ###############
  describe "#id_and_bookmark",tag_id_and_bookmark:true do
    it "should be id_and_bookmark" do
      @bookmark.id_and_bookmark == @bookmark.id.to_s+"."+@bookmark.title.to_s+"-iframe:"+@bookmark.i_frame+'-'+@bookmark.bookmark_url
    end
  end




end
