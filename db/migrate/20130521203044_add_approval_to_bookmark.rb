class AddApprovalToBookmark < ActiveRecord::Migration
  def change
    add_column :bookmarks, :approval, :integer ,:default => 0
  end
end
