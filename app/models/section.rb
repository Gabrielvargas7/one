class Section < ActiveRecord::Base
  attr_accessible :description, :name

  has_many :locations
  has_many :bundles
  has_many :users_themes

  validates :name, presence:true

  def id_and_section
    "#{id}. #{name}"
  end


end
