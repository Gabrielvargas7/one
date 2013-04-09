class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.decimal :x
      t.decimal :y
      t.integer :z
      t.integer :width
      t.integer :height
      t.string :clickable
      t.string :image_name

      t.timestamps
    end
  end
end
