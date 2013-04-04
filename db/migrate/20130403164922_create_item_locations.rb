class CreateItemLocations < ActiveRecord::Migration
  def change
    create_table :item_locations do |t|
      t.string :name
      t.decimal :x , :precision => 6, :scale => 2
      t.float :y
      t.integer :z
      t.integer :width
      t.integer :height
      t.string :clickable

      t.timestamps
    end
  end
end
