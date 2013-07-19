class AddIndexToUsersItemsLocation < ActiveRecord::Migration
  def change
    add_index :items_locations, :item_id
    add_index :items_locations, :location_id
  end
end
