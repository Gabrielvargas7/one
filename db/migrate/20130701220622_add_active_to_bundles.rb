class AddActiveToBundles < ActiveRecord::Migration
  def change
    add_column :bundles, :active, :string, default: 'n'
    #add_column :accounts, :ssl_enabled, :boolean, default: true
  end
end
