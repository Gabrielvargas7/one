class AddIndexIdToThemes < ActiveRecord::Migration
  def self.up
    add_index :themes, :id
    add_index :themes, :name
  end

  def self.down
    remove_index :themes, :id
    remove_index :themes, :name
  end


end
