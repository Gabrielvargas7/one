# == Schema Information
#
# Table name: friends
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  user_id_friend :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'spec_helper'

describe Friend do
  pending "add some examples to (or delete) #{__FILE__}"
end
