class CreateUsersPhotos < ActiveRecord::Migration
  def change
    create_table :users_photos do |t|
      t.integer :user_id
      t.string :description
      t.string :image_name
      t.string :profile_image, default: 'n'

      t.timestamps
    end
  end
end
