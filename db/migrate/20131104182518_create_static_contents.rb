class CreateStaticContents < ActiveRecord::Migration
  def change
    create_table :static_contents do |t|
      t.string :name
      t.string :image_name
      t.string :description

      t.timestamps
    end
  end
end
