# == Schema Information
#
# Table name: users_bookmarks
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  bookmark_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  position    :integer
#

require 'spec_helper'

describe UsersBookmark do
  pending "add some examples to (or delete) #{__FILE__}"
end
