class AddIndexToItemsDesigns < ActiveRecord::Migration
  def self.up
    add_index :items_designs, :id
    add_index :items_designs, :item_id
    add_index :items_designs, :name
    add_index :items_designs, :bundle_id
  end

  def self.down
    remove_index :items_designs, :id
    remove_index :items_designs, :item_id
    remove_index :items_designs, :name
    remove_index :items_designs, :bundle_id

  end

end
