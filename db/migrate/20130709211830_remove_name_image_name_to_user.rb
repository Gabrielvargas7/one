class RemoveNameImageNameToUser < ActiveRecord::Migration
  def up
    remove_column :users, :image_name
    remove_column :users, :name
  end


  def down
  end
end
