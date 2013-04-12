require "fileutils"
module SeedBundleImagesModule

  def self.transfer_bundles_image

    Dir["/home/rooms/projects/rails/images/bundle/*.png"].each do  |image_path|

        app_image_path = "/home/rooms/projects/rails/mywebroom/app/assets/images/bundles/"
        popthumb = "popthumb"
        thumb = "thumb"

      #p image_path

        fix_image_name = image_path.clone


        fix_image_name = Image::ImageNameHelper.fix_image_name fix_image_name

      #p fix_image_name
      #p image_path

        array_fix_image_name = fix_image_name.split('/')

        image_new_name = array_fix_image_name.last +  Image::ImageNameHelper::EXTENSION_PNG

        p app_image_path + image_new_name

        p image_path

        FileUtils.cp  image_path , app_image_path + image_new_name

    end
  end

end