class AddOneTimeLoginToUserProfile < ActiveRecord::Migration
  def change
    add_column :users_profiles, :password_reset_on_login, :boolean, :default => false
  end
end
