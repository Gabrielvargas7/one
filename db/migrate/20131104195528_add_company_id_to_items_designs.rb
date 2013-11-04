class AddCompanyIdToItemsDesigns < ActiveRecord::Migration
  def change
    add_column :items_designs, :company_id,:integer
    remove_columns :items_designs, :image_name_logo
  end
end
