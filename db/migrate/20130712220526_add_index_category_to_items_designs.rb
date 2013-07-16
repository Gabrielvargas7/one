class AddIndexCategoryToItemsDesigns < ActiveRecord::Migration
  def change
        add_index :items_designs, :description
        add_index :items_designs, :category
        add_index :items_designs, :style
        add_index :items_designs, :brand
        add_index :items_designs, :color
        add_index :items_designs, :make
        add_index :items_designs, :special_name


  end
end
