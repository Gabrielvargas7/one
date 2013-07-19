class AddIndexToUsersProfiles2 < ActiveRecord::Migration
  def change
        add_index :users_profiles, :birthday
        add_index :users_profiles, :city
        add_index :users_profiles, :country
        add_index :users_profiles, :description
        add_index :users_profiles, :firstname
        add_index :users_profiles, :lastname
        add_index :users_profiles, :gender
  end
end
