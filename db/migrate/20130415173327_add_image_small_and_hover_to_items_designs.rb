class AddImageSmallAndHoverToItemsDesigns < ActiveRecord::Migration
  def change
    add_column :items_designs, :image_name_hover, :string
    add_column :items_designs, :image_small, :string
  end
end
