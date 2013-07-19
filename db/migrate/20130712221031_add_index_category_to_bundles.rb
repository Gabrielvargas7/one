class AddIndexCategoryToBundles < ActiveRecord::Migration
  def change
    add_index :bundles, :description
    add_index :bundles, :special_name
    add_index :bundles, :make
    add_index :bundles, :color
    add_index :bundles, :location
    add_index :bundles, :style
    add_index :bundles, :brand
    add_index :bundles, :category
  end
end
