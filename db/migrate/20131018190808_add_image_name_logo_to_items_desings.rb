class AddImageNameLogoToItemsDesings < ActiveRecord::Migration
  def change
    add_column :items_designs,:image_name_logo,:string
    add_column :items,:image_name_gray,:string

  end
end
