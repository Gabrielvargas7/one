class UsersTheme < ActiveRecord::Base
  attr_accessible :theme_id, :user_id

  belongs_to :theme
  belongs_to :user


end
