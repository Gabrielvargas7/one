class AddImageNameToUsers < ActiveRecord::Migration

  def up
     add_column :users, :image_name, :string
  end

  def down
  end
end
