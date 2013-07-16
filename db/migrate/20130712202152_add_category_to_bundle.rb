class AddCategoryToBundle < ActiveRecord::Migration
  def change
    add_column :bundles, :category, :string
    add_column :bundles, :style, :string
    add_column :bundles, :brand, :string
    add_column :bundles, :location, :string
    add_column :bundles, :color, :string
    add_column :bundles, :make, :string
    add_column :bundles, :special_name,:string
    add_column :bundles, :like, :integer
  end
end
