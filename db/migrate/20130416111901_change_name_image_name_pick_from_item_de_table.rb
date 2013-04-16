class ChangeNameImageNamePickFromItemDeTable < ActiveRecord::Migration
  def up
    rename_column :items_designs, :image_name_pick, :image_name_selection
  end

  def down
  end
end
