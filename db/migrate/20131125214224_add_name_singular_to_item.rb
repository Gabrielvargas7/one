class AddNameSingularToItem < ActiveRecord::Migration
  def change
    add_column :items, :name_singular, :string
  end
end
