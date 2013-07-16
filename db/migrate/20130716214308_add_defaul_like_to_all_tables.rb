class AddDefaulLikeToAllTables < ActiveRecord::Migration
  def change
    change_column_default :bookmarks, :like, 0
    change_column_default :themes, :like, 0
    change_column_default :items_designs, :like, 0
    change_column_default :bundles, :like, 0

  end
end
