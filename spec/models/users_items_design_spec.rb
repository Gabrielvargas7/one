# == Schema Information
#
# Table name: users_items_designs
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  items_design_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  hide            :string(255)
#

require 'spec_helper'

describe UsersItemsDesign do
  pending "add some examples to (or delete) #{__FILE__}"
end
