class AddLocationIdToUsersItemsDesign < ActiveRecord::Migration
  def change
    add_column :users_items_designs, :location_id, :integer ,:default => 0
  end
end
