class AddIndexToUsers < ActiveRecord::Migration    \

  def self.up
    add_index :users, :id
    add_index :users, :name
    add_index :users, :username
    add_index :users, :admin
  end

  def self.down
    remove_index :users, :id
    remove_index :users, :name
    remove_index :users, :username
    remove_index :users, :admin

  end

end
