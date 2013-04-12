class ChangeImageNameForFolderNameToItems < ActiveRecord::Migration
  def up
    rename_column :items, :image_name, :folder_name
  end

  def down
  end
end
