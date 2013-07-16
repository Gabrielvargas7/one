class AddIndexCategoryToThemes < ActiveRecord::Migration
  def change
    add_index :themes, :description
    add_index :themes, :special_name
        add_index :themes, :make
        add_index :themes, :color
        add_index :themes, :location
        add_index :themes, :style
        add_index :themes, :brand
        add_index :themes, :category
  end
end
