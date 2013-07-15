class CreateUsersProfiles < ActiveRecord::Migration
  def change
    create_table :users_profiles do |t|
      t.string :firstname
      t.string :lastname
      t.string :gender
      t.string :description
      t.string :city
      t.string :country
      t.date :birthday
      t.integer :user_id

      t.timestamps
    end
  end
end
