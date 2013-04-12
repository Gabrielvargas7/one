class DeleteItemLocationTable < ActiveRecord::Migration
  def up
    drop_table :item_locations
  end

  def down
  end
end
