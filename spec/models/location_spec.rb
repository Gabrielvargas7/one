require 'spec_helper'

describe Location do

  #attr_accessible  :height, :name, :width, :x, :y, :z
  # the (before) line will instance the variable for every (describe methods)
  #before { @item = Item.new()}

  before do
    @section = FactoryGirl.create(:section)
    @location = FactoryGirl.build(:location,section_id:@section.id )

  end


  #the (subject)line declare the variable that is use in all the test
  subject { @location }

  #theme info
  it { @location.should respond_to(:name) }
  it { @location.should respond_to(:description) }
  it { @location.should respond_to(:section_id) }
  it { @location.should respond_to(:height)}
  it { @location.should respond_to(:width)}
  it { @location.should respond_to(:x) }
  it { @location.should respond_to(:y) }
  it { @location.should respond_to(:z) }

  it { @location.should be_valid }


  ###############
  #test validation section id is present
  ###############
  describe " section_id ",tag_section_id:true do
    it "should be valid " do
      @location.section_id == @section.id
    end
  end

  ###############
  #test validation section id is not valid
  ###############

  describe "should not be valid item id ",tag_section_id:true do

    let(:location_not_section_id){FactoryGirl.build(:location,section_id:-1 )}
    it { location_not_section_id.should_not be_valid }

  end



  ###############
  #test validation - height
  ###############

  describe "when height" , tag_height: true  do

    context "is nil " do
      before {@location.height = nil }
      it {should_not be_valid}
    end
    context " is not integer '1.1' " do
      before {@location.height = 1.1 }
      it {should_not be_valid}
    end
    context " is number and integer " do
      before {@location.height = 1 }
      it {should be_valid}
    end
  end


  ###############
  #test validation - width
  ###############

  describe "when width" , tag_width: true  do

    context "is nil " do
      before {@location.width = nil }
      it {should_not be_valid}
    end
    context " is not integer '1.1' " do
      before {@location.width = 1.1 }
      it {should_not be_valid}
    end
    context " is number and integer " do
      before {@location.width = 1 }
      it {should be_valid}
    end
  end

  ###############
  #test validation - x
  ###############

  describe "when x" , tag_x: true  do

    context "is nil " do
      before {@location.x = nil }
      it {should_not be_valid}
    end
    context " is not integer '1.1' " do
      before {@location.x = 1.1 }
      it {should be_valid}
    end
    context " is number and integer " do
      before {@location.x = 1 }
      it {should be_valid}
    end
  end


  ###############
  #test validation - y
  ###############

  describe "when y" , tag_y: true  do

    context "is nil " do
      before {@location.y = nil }
      it {should_not be_valid}
    end
    context " is not integer '1.1' " do
      before {@location.y = 1.1 }
      it {should be_valid}
    end
    context " is number and integer " do
      before {@location.y = 1 }
      it {should be_valid}
    end
  end


  ###############
  #test validation - y
  ###############

  describe "when z" , tag_z: true  do

    context "is nil " do
      before {@location.z = nil }
      it {should_not be_valid}
    end
    context " is not integer '1.1' " do
      before {@location.z = 1.1 }
      it {should_not be_valid}
    end
    context " is number and integer " do
      before {@location .z = 1 }
      it {should be_valid}
    end
  end


  ###############
  #test function - id_and_location_section
  ###############
  describe "when the function id_and_location_section" , tag_function: true  do

    context "get id and location and section" do
      before do

          @name = "location_name"
          @location.name = @name
          @location.save!
          @id = @location.id
          @section_id = @location.section_id
          @section_name = @location.section.name

      end

      it "should print the id and location and section " do
        #puts @location.id_and_location_section
        #@item.id_and_item.should ==  @id.to_s+". "+@name
        @location.id_and_location_section.should ==  "Location: "+@id.to_s+". "+@name+" --Section: "+@section_id.to_s+". "+@section_name

      end


    end
  end




end
