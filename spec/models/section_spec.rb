require 'spec_helper'

describe Section do
  #attr_accessible :clickable, :folder_name, :height, :name, :width, :x, :y, :z
  # the (before) line will instance the variable for every (describe methods)
  #before { @item = Item.new()}

  before {@section = FactoryGirl.build(:section) }


  #the (subject)line declare the variable that is use in all the test
  subject { @section }

  #theme info
  it { @section.should respond_to(:name) }
  it { @section.should respond_to(:description) }

  it { @section.should be_valid }


  ###############
  #test validation - name
  ###############
  describe "when the name" , tag_name: true  do

    context "is not present" do
      before {@section.name = " "}

      it "should be upload to CDN - cloudinary " do
        should_not be_valid
      end
    end
  end

  ###############
  #test function - id_and_section
  ###############
  describe "when the function id_and_section" , tag_function: true  do

    context "get id and name" do
      before do

        @name = "section_name"
        @section.name = @name
        @section.save!
        @id = @section.id
      end

      it "should print the id and name  " do
        #puts @section.id_and_section
        @section.id_and_section.should ==  @id.to_s+". "+@name

      end


    end
  end




end
