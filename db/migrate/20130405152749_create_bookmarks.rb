class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.integer :bookmarks_category_id
      t.string :bookmark_url
      t.string :title
      t.string :i_frame
      t.string :image_name

      t.timestamps
    end
  end
end
