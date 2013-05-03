class ChangeProfileImageToDefaultImageToUsersGalleries < ActiveRecord::Migration
  def up
    rename_column :users_galleries, :profile_image, :default_image
  end

  def down
  end
end
