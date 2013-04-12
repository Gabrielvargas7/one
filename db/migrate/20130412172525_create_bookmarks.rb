class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.integer :bookmarks_category_id
      t.integer :item_id
      t.string :bookmark_url
      t.string :title
      t.string :i_frame
      t.string :image_name
      t.string :image_name_desc
      t.text :description

      t.timestamps
    end
  end
end
