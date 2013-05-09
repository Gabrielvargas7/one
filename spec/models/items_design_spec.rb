# == Schema Information
#
# Table name: items_designs
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  description          :text
#  item_id              :integer
#  bundle_id            :integer
#  image_name           :string(255)
#  image_name_hover     :string(255)
#  image_name_selection :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

require 'spec_helper'

describe ItemsDesign do
  pending "add some examples to (or delete) #{__FILE__}"
end
