class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.string :description
      t.decimal :x
      t.decimal :y
      t.integer :z
      t.integer :width
      t.integer :height
      t.integer :section_id

      t.timestamps
    end
  end
end
