class DeletePriceAndProductUrlToUsersProfiles < ActiveRecord::Migration
  def up
    remove_column :users_profiles,:price
    remove_column :users_profiles,:product_url
  end

  def down
  end
end
