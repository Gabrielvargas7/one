class CreateTutorials < ActiveRecord::Migration
  def change
    create_table :tutorials do |t|
      t.string :name
      t.string :image_name
      t.string :description
      t.integer :step

      t.timestamps
    end
  end
end
