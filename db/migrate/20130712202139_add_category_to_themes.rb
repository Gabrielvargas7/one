class AddCategoryToThemes < ActiveRecord::Migration
  def change
    add_column :themes, :category, :string
    add_column :themes, :style, :string
    add_column :themes, :brand, :string
    add_column :themes, :location, :string
    add_column :themes, :color, :string
    add_column :themes, :make, :string
    add_column :themes, :special_name, :string
    add_column :themes, :like, :integer
  end
end
