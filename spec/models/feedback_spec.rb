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
  pending "add some examples to (or delete) #{__FILE__}"
end
