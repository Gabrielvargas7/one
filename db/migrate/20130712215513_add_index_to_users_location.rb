class AddIndexToUsersLocation < ActiveRecord::Migration
  def change
        add_index :locations, :description
        add_index :locations, :name
  end
end
