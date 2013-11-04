class AddEntireRoomImageToBundles < ActiveRecord::Migration
  def change
    add_column :bundles, :image_name_entire_room, :string
  end
end
