class AddNumberFriendsToUsersProfile < ActiveRecord::Migration
  def change
    add_column :users_profiles, :friends_number, :integer, default: 0

  end
end
