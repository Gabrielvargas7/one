class CreateBundlesItemsDesigns < ActiveRecord::Migration
  def change
    create_table :bundles_items_designs do |t|
      t.integer :items_design_id
      t.integer :location_id
      t.integer :bundle_id

      t.timestamps
    end
  end
end
