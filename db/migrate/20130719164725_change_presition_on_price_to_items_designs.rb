class ChangePresitionOnPriceToItemsDesigns < ActiveRecord::Migration
  def up
    change_column :items_designs, :price,:decimal, :precision => 8, :scale => 2
  end

  def down
  end
end
