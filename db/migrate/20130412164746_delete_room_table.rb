class DeleteRoomTable < ActiveRecord::Migration
  def up
    drop_table :rooms
  end

  def down
  end
end
