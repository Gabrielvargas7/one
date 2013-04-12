require "fileutils"
module SeedBookmarksImageModule

  def self.transfer_bookmarks_image

    Dir["/home/rooms/projects/rails/images/bookmarks/**/*.png"].each do  |image_path|

      app_image_path = "/home/rooms/projects/rails/mywebroom/app/assets/images/bookmarks/"
      popthumb = "popthumb"
      thumb = "thumb"
      file_name = "(100x100)"

      #p image_path

      fix_image_name = image_path.clone

      if fix_image_name.index(file_name)

          fix_image_name = Image::ImageNameHelper.fix_image_name fix_image_name

          #p fix_image_name
          #p image_path

          array_fix_image_name = fix_image_name.split('/')


          l = array_fix_image_name.length

          #p array_fix_image_name[l-1]

          image_new_name = array_fix_image_name[l-1] +  Image::ImageNameHelper::EXTENSION_PNG

          #p array_fix_image_name[l-2]

          new_folder_item_name = array_fix_image_name[l-3]

          #new_folder_item_name = folder_item_name.split("(100x100)")

          if Bookmark.where(image_name:image_new_name).exists?

            @bookmark = Bookmark.find_by_image_name(image_new_name)

            #p new_folder_item_name
            if Item.where(folder_name: new_folder_item_name).exists?


              # the item exist
              #@item = Item.find(@bookmark.item_id)
              #p "Item id: "+@item.folder_name.to_s
              #p image_new_name

              item_path =  new_folder_item_name
              app_image_path = app_image_path + item_path+"/"

            end

          end

           p app_image_path +  image_new_name
           #
           # p image_path

          FileUtils.cp  image_path , app_image_path + image_new_name





      end
      end

    end
  end