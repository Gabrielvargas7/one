class AddFirstTimeClickToItems < ActiveRecord::Migration
  def change
    add_column :items, :image_name_first_time_click, :string
  end
end
