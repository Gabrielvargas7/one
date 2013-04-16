class ChangeNameImageNameSmallFromItemDeTable < ActiveRecord::Migration
  def up
    rename_column :items_designs, :image_name_small, :image_name_pick
  end

  def down
  end
end
