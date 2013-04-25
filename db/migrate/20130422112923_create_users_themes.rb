class CreateUsersThemes < ActiveRecord::Migration
  def change
    create_table :users_themes do |t|
      t.integer :user_id
      t.integer :theme_id

      t.timestamps
    end
  end
end
