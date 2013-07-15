class DropUserGallery < ActiveRecord::Migration
  def up
    drop_table :users_galleries
  end

  def down
  end
end
