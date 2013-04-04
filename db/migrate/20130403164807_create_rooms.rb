class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.integer :user_id
      t.integer :item_id
      t.integer :theme_id

      t.timestamps
    end
  end
end
