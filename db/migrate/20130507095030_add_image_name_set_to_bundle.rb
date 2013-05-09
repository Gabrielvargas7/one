class AddImageNameSetToBundle < ActiveRecord::Migration
  def change
    add_column :bundles, :image_name_set, :string
  end
end
