class DeleteXyzToItems < ActiveRecord::Migration
  def up
    remove_column :items, :folder_name
    remove_column :items, :height
    remove_column :items, :width
    remove_column :items, :x
    remove_column :items, :y
    remove_column :items, :z


  end

  def down
  end
end
