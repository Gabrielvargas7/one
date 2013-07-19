class AddActiveToBundles < ActiveRecord::Migration
  def change
    add_column :bundles, :active, :string, default: 'n'
  end
end
