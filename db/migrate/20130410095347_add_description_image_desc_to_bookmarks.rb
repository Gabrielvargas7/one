class AddDescriptionImageDescToBookmarks < ActiveRecord::Migration
  def change
    add_column :bookmarks, :image_name_desc, :string
    add_column :bookmarks, :description, :text
  end
end
