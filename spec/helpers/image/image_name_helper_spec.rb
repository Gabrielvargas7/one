require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the Image::ImageNameHelper. For example:
#
# describe Image::ImageNameHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe Image::ImageNameHelper do

  #pending "add some examples to (or delete) #{__FILE__}"

     describe "image name" do
       it "remove space of the name " do

         image_to_fix = "Bed With Space"
         image_fix = "bed-with-space"

         test_image_fix = ImageNameHelper.fix_image_name image_to_fix
         image_fix should == test_image_fix


       end

     end



end
