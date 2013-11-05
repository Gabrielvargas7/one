class AddFirstTimeClickToUsersItemsDesigns < ActiveRecord::Migration
  def change
    add_column :users_items_designs, :first_time_click, :string, default: 'y'
  end
end
