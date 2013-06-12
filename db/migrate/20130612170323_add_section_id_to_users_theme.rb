class AddSectionIdToUsersTheme < ActiveRecord::Migration
  def change
    add_column :users_themes, :section_id, :integer
  end
end
