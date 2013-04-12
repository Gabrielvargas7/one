class DeleteThemesTable < ActiveRecord::Migration
  def up
    drop_table :themes
  end

  def down
  end
end
