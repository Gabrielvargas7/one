class DropAdvertisementsTableToAdvertisements < ActiveRecord::Migration
  def up

    drop_table :advertisements

  end

  def down

  end
end