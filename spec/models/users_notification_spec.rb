# == Schema Information
#
# Table name: users_notifications
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  notification_id :integer          default(0)
#  notified        :string(255)      default("y"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe UsersNotification do
  pending "add some examples to (or delete) #{__FILE__}"
end
