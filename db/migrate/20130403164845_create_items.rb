class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.text :description
      t.integer :item_location_id
      t.integer :bundle_id

      t.timestamps
    end
  end
end
