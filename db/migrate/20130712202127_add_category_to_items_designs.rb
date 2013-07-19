class AddCategoryToItemsDesigns < ActiveRecord::Migration
  def change
    add_column :items_designs, :category, :string
    add_column :items_designs, :style, :string
    add_column :items_designs, :brand, :string
    add_column :items_designs, :color, :string
    add_column :items_designs, :make, :string
    add_column :items_designs, :special_name, :string
    add_column :items_designs, :like, :integer

  end
end
