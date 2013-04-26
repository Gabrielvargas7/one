class AddHideFieldToUsersItemsDesign < ActiveRecord::Migration
  def change
    add_column :users_items_designs, :hide, :string
  end
end
