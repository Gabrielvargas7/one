class AddSectionIdToBundle < ActiveRecord::Migration
  def change
    add_column :bundles, :section_id, :integer
  end
end
