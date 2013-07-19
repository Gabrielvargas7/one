class ChangePresitionToLocation1 < ActiveRecord::Migration
  def up
    change_column :locations, :x,:decimal, :precision => 8, :scale => 1
    change_column :locations, :y,:decimal, :precision => 8, :scale => 1
  end

  def down
  end
end
