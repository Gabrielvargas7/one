class AddIndexToItems < ActiveRecord::Migration

  def self.up
    add_index :items, :id
    add_index :items, :name

  end

  def self.down
    remove_index :items, :id
    remove_index :items, :name
  end

end
