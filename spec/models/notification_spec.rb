# == Schema Information
#
# Table name: notifications
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  image_name  :string(255)
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text
#  position    :integer
#

require 'spec_helper'

describe Notification do
  pending "add some examples to (or delete) #{__FILE__}"
end
