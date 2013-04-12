class CreateBookmarksCategories < ActiveRecord::Migration
  def change
    create_table :bookmarks_categories do |t|
      t.string :name
      t.integer :item_id

      t.timestamps
    end
  end
end
