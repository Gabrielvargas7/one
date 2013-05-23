# == Schema Information
#
# Table name: themes
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  description          :text
#  image_name           :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  image_name_selection :string(255)
#

require 'spec_helper'

describe Theme do

  #theme = Theme.new
  #  theme.name ="juppy"
  #  theme.save
  #it "it theme name 'juppy '" do
  #  theme.name.should =='juppy'
  #
  #end
end
