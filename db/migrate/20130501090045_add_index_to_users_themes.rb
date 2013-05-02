class AddIndexToUsersThemes < ActiveRecord::Migration
  def self.up
    add_index :users_themes, :id
    add_index :users_themes, :user_id
    add_index :users_themes, :theme_id


  end

  def self.down
    remove_index :users_themes, :id
    remove_index :users_themes, :user_id
    remove_index :users_themes, :theme_id


  end

end
