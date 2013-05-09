# == Schema Information
#
# Table name: bundles
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  description    :text
#  theme_id       :integer
#  image_name     :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  image_name_set :string(255)
#

require 'spec_helper'

describe Bundle do
  pending "add some examples to (or delete) #{__FILE__}"
end
