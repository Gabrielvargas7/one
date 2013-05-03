class CreateUsersGalleries < ActiveRecord::Migration
  def change
    create_table :users_galleries do |t|
      t.integer :user_id
      t.string :image_name
      t.boolean :profile_image

      t.timestamps
    end
  end
end
