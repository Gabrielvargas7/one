class AddDefaultIFrameToBookmark < ActiveRecord::Migration

  def self.up
    change_column_default :bookmarks, :i_frame, 'y'

  end

  def self.down

  end

end
