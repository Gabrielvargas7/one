class AddIndexToUsersPhotos < ActiveRecord::Migration
  def change
        add_index :users_photos, :user_id
        add_index :users_photos, :description
        add_index :users_photos, :profile_image
  end
end
