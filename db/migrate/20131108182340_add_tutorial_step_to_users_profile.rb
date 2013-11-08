class AddTutorialStepToUsersProfile < ActiveRecord::Migration
  def change
    add_column :users_profiles, :tutorial_step,:integer, :default => '0'
  end
end
