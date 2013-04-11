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

     imageNameHelper = Image::ImageNameHelper
     subject { imageNameHelper }

     describe "image name" do

       it "remove space of the name " do
         image_to_fix = "Bed With Space.jpg"

         test_image_fix = imageNameHelper.remove_space_image_name image_to_fix

         test_image_fix.should eq("bed-with-space.jpg")
       end

       it "remove extension and space of the name " do
         image_to_fix = "Bed With Space .jpg"

         not_extension_image_fix = imageNameHelper.remove_image_extension image_to_fix
         clean_image_fix = imageNameHelper.remove_space_image_name not_extension_image_fix

         clean_image_fix.should eq("bed-with-space")
       end

       it "fix_image_name remove extension and space of the name " do
         image_to_fix = "Bed With Space .jpg"

         test_image_fix = imageNameHelper.fix_image_name image_to_fix

         test_image_fix.should eq("bed-with-space")
       end





     it "test no self methods on the module " do
         image_to_fix = "Bed With Space"

         @testImageNameHelper =  TestImageNameHelper.new
         test_image_fix = @testImageNameHelper.no_self_fix_image_name  image_to_fix

         test_image_fix.should eq("bed-with-space")
       end
     end
end

class TestImageNameHelper
    include Image::ImageNameHelper
end

