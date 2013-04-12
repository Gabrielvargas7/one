class DeleteItemsDesignTable < ActiveRecord::Migration
  def up
    drop_table :items_designs
  end

  def down
  end
end
