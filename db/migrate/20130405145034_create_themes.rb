class CreateThemes < ActiveRecord::Migration
  def change
    create_table :themes do |t|
      t.string :name
      t.text :description
      t.string :image_name

      t.timestamps
    end
  end
end
