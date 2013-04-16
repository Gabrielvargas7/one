class AddImagePopthumbToThemes < ActiveRecord::Migration
  def change
    add_column :themes, :image_popthumb, :string
  end
end
