class DeleteColumnDefaultValueToUsersGallery < ActiveRecord::Migration
  def up
    remove_column :users_galleries, :default_image
  end

  def down
  end
end
