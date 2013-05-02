class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.integer :user_id
      t.integer :user_id_friend

      t.timestamps
    end
  end
end
