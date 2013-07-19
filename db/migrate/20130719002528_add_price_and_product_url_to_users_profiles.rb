class AddPriceAndProductUrlToUsersProfiles < ActiveRecord::Migration
  def change
    add_column :users_profiles,:price,:decimal,default: 0
    add_column :users_profiles,:product_url,:string
  end
end
