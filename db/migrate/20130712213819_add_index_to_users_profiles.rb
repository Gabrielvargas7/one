class AddIndexToUsersProfiles < ActiveRecord::Migration
  def change
    add_index :users_profiles, :user_id, unique: true
  end
end
