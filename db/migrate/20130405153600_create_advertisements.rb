class CreateAdvertisements < ActiveRecord::Migration
  def change
    create_table :advertisements do |t|
      t.string :image_name
      t.string :description
      t.integer :bookmark_id

      t.timestamps
    end
  end
end
