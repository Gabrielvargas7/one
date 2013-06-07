class AddDefaultValuesToItems2 < ActiveRecord::Migration
  def self.up
    change_column_default :items, :clickable, 'yes'
    change_column_default :items, :x, 0
    change_column_default :items, :y, 0
    change_column_default :items, :z, 0
    change_column_default :items, :height, 0
    change_column_default :items, :width, 0
  end

  def self.down

  end

end
