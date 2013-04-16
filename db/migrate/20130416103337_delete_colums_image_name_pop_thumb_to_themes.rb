class DeleteColumsImageNamePopThumbToThemes < ActiveRecord::Migration
  def up
    remove_column :themes, :image_popthumb
  end

  def down
  end
end
