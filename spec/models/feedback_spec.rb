# == Schema Information
#
# Table name: feedbacks
#
#  id          :integer          not null, primary key
#  description :text
#  user_id     :integer
#  name        :string(255)
#  email       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Feedback do

  before do
    @feedback= FactoryGirl.build(:feedback)
  end


  #the (subject)line declare the variable that is use in all the test
  subject { @feedback }

  #theme info
  it { @feedback.should respond_to(:name) }
  it { @feedback.should respond_to(:description) }
  it { @feedback.should respond_to(:email)}
  it { @feedback.should respond_to(:user_id)}
  it { @feedback.should be_valid }


end
