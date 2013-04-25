class CreateUsersItemsDesigns < ActiveRecord::Migration
  def change
    create_table :users_items_designs do |t|
      t.integer :user_id
      t.integer :items_design_id

      t.timestamps
    end
  end
end
