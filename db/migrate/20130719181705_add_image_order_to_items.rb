class AddImageOrderToItems < ActiveRecord::Migration
  def change
    add_column :items,:image_name,:string
    add_column :items,:priority_order,:integer, :default => 0
  end
end
