# == Schema Information
#
# Table name: bookmarks
#
#  id                    :integer          not null, primary key
#  bookmarks_category_id :integer
#  item_id               :integer
#  bookmark_url          :text
#  title                 :string(255)
#  i_frame               :string(255)      default("y")
#  image_name            :string(255)
#  image_name_desc       :string(255)
#  description           :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'spec_helper'

describe Bookmark do
  pending "add some examples to (or delete) #{__FILE__}"
end
