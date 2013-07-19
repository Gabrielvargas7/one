class PriceAndProductUrlToItemsDesigns < ActiveRecord::Migration
  def up
    add_column :items_designs,:price,:decimal,default: 0
    add_column :items_designs,:product_url,:string


  end

  def down
  end
end
