# == Schema Information
#
# Table name: static_contents
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  image_name      :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  description     :string(255)
#

require 'spec_helper'

describe StaticContent do


  # the (before) line will instance the variable for every (describe methods)
  #before { @static_content = static_content.new(name: "Example Name", image_name: "example image name", description: "Example description.", step: 1)}

  before(:all){ create_init_data }
  after(:all){ delete_init_data }
  before {@static_content = FactoryGirl.build(:static_content) }

  #the (subject)line declare the variable that is use in all the test
  subject { @static_content }


  #static_content info

  it { @static_content.should respond_to(:name) }
  it { @static_content.should respond_to(:image_name)}
  it { @static_content.should respond_to(:description) }


  it { @static_content.should be_valid }


  ###############
  #test validation
  ###############
  describe "when name", tag_password: true  do
      context "is not present" do
        before { @static_content.name = nil }
        it { @static_content.should_not be_valid }
      end

  end


end
