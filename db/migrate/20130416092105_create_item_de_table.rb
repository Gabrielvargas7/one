class CreateItemDeTable < ActiveRecord::Migration
  def change
    create_table :items_designs do |t|
      t.string :name
      t.text :description
      t.integer :item_id
      t.integer :bundle_id
      t.string :image_name
      t.string :image_name_hover
      t.string :image_name_small
      t.timestamps
    end
  end
end
