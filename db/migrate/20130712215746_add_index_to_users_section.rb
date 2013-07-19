class AddIndexToUsersSection < ActiveRecord::Migration
  def change
    add_index :sections, :description
        add_index :sections, :name
  end
end
