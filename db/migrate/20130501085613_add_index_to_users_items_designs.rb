class AddIndexToUsersItemsDesigns < ActiveRecord::Migration
  def self.up
    add_index :users_items_designs, :id
    add_index :users_items_designs, :user_id
    add_index :users_items_designs, :items_design_id

  end

  def self.down
    remove_index :users_items_designs, :id
    remove_index :users_items_designs, :user_id
    remove_index :users_items_designs, :items_design_id

  end

end
