# == Schema Information
#
# Table name: companies
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  image_name      :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  description     :string(255)
#

require 'spec_helper'

describe Company do


  # the (before) line will instance the variable for every (describe methods)
  #before { @company = Company.new(name: "Example Name", image_name: "example image name", description: "Example description.", step: 1)}

  before(:all){ create_init_data }
  after(:all){ delete_init_data }
  before { @company  = FactoryGirl.build(:company) }
  before { @company2 = Company.new(description: "description", name: "name") }

  #the (subject)line declare the variable that is use in all the test
  subject { @company }


  #company info

  it { @company.should respond_to(:description) }
  it { @company.should respond_to(:image_name)}
  it { @company.should respond_to(:name) }


  it { @company.should be_valid }


  ###############
  #test validation
  ###############
  describe "when name", tag_password: true  do
      context "is a duplicate" do
        before { @company2 = Company.create(description: "description 1", name: "name") }
        before { @company3 = Company.new(description: "description 2", name: "name") }
        it { @company3.should_not be_valid }
      end

  end


end

