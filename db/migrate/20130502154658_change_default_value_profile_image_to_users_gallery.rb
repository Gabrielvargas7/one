class ChangeDefaultValueProfileImageToUsersGallery < ActiveRecord::Migration
  def up
    change_column_default :users_galleries, :profile_image, false
  end

  def down
  end
end
