# == Schema Information
#
# Table name: themes
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  description          :text
#  image_name           :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  image_name_selection :string(255)
#

require 'spec_helper'

describe Theme do
  pending "add some examples to (or delete) #{__FILE__}"
end
