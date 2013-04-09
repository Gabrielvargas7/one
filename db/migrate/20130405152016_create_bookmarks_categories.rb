class CreateBookmarksCategories < ActiveRecord::Migration
  def change
    create_table :bookmarks_categories do |t|
      t.integer :item_id
      t.string :name

      t.timestamps
    end
  end
end
