require "fileutils"
module SeedThemeImagesModule

  def self.transfer_themes_image

    Dir["/home/rooms/projects/rails/images/themes/**/*.jpg"].each do  |image_path|

      #app_image_path = "/home/rooms/projects/rails/mywebroom/app/assets/images/themes/"
      app_image_path = "/home/rooms/projects/rails/mywebroom/public/uploads/theme/image_name/"
      popthumb = "popthumb"
      thumb = "thumb"

      #p image_path

      fix_image_name = image_path.clone


      fix_image_name = Image::ImageNameHelper.fix_image_name fix_image_name

      #p fix_image_name
      #p image_path

      array_fix_image_name = fix_image_name.split('/')

      l = array_fix_image_name.length

      if array_fix_image_name.last.eql?(array_fix_image_name[l-2])

        image_new_name = array_fix_image_name[l-2]

        image_new_name = image_new_name +  Image::ImageNameHelper::EXTENSION_JPG

        p app_image_path + image_new_name

        p image_path

        FileUtils.cp  image_path , app_image_path + image_new_name

      end

      if array_fix_image_name.last.eql?(popthumb)

      image_new_name =  array_fix_image_name[l-2]+"-"+array_fix_image_name[l-1]

      image_new_name = image_new_name +  Image::ImageNameHelper::EXTENSION_JPG

      p app_image_path + image_new_name

      p image_path

      FileUtils.cp  image_path , app_image_path + image_new_name

      end

    end
  end

end