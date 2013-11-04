class AddUniqueNameToStaticContents < ActiveRecord::Migration
  def change
    add_index :static_contents, :name, unique: true
  end
end
