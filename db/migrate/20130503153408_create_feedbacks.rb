class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.text :description
      t.integer :user_id
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
