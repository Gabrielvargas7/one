# == Schema Information
#
# Table name: tutorials
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  image_name  :string(255)
#  description :string(255)
#  step        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Tutorial do


  # the (before) line will instance the variable for every (describe methods)
  #before { @tutorial = Tutorial.new(name: "Example Name", image_name: "example image name", description: "Example description.", step: 1)}

  before(:all){ create_init_data }
  after(:all){ delete_init_data }
  before {@tutorial = FactoryGirl.build(:tutorial) }

  #the (subject)line declare the variable that is use in all the test
  subject { @tutorial }


  #tutorial info

  it { @tutorial.should respond_to(:name) }
  it { @tutorial.should respond_to(:image_name)}
  it { @tutorial.should respond_to(:description) }
  it { @tutorial.should respond_to(:step) }


  it { @tutorial.should be_valid }


  ###############
  #test validation
  ###############
  describe "when step ", tag_password: true  do
      context "is not present" do
        before { @tutorial.step = nil }
        it { @tutorial.should_not be_valid }
      end

  end


end
