class AddImageNameSelectionToThemes < ActiveRecord::Migration
  def change
    add_column :themes, :image_name_selection, :string
  end
end
