class DeleteBundleTable < ActiveRecord::Migration
  def up
    drop_table :bundles
  end

  def down
  end
end
