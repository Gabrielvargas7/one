class UsersItemsDesign < ActiveRecord::Base
  attr_accessible :items_design_id, :user_id

  belongs_to :user
  belongs_to :items_design
end
