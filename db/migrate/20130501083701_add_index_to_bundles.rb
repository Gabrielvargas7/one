class AddIndexToBundles < ActiveRecord::Migration

  def self.up
    add_index :bundles, :id
    add_index :bundles, :theme_id
    add_index :bundles, :name

  end

  def self.down
    remove_index :bundles, :id
    remove_index :bundles, :theme_id
    remove_index :bundles, :name
  end



end
