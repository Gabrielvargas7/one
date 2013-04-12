require "fileutils"
module SeedItemsImagesModule

  def self.transfer_items_image_main

    Dir["/home/rooms/projects/rails/images/objects/**/*.png"].each do  |image_path|

      app_image_path = "/home/rooms/projects/rails/mywebroom/app/assets/images/items-designs/"
      #app_image_path = "/home/rooms/projects/rails/mywebroom/app/assets/images/bookmarks/"
      popthumb = "popthumb"
      thumb = "thumb"

      #p image_path

      fix_image_name = image_path.clone

      ### fix if the image is T.v.
       if fix_image_name.index("T.V.")

         if fix_image_name.index("T.V._h")

           index_image = fix_image_name.index("T.V._")
           fix_image_name[index_image] = 't'
           fix_image_name[index_image+1] = 'v'
           fix_image_name[index_image+2] = '_'
           fix_image_name[index_image+3] = 'h'
           fix_image_name[index_image+4] = ' '
           fix_image_name[index_image+5] = ' '

         else
         index_image = fix_image_name.index("T.V.")
          fix_image_name[index_image] = 't'
          fix_image_name[index_image+1] = 'v'
          fix_image_name[index_image+2] = ' '
          fix_image_name[index_image+3] = ' '
         end
       end




      fix_image_name = Image::ImageNameHelper.fix_image_name fix_image_name
      #p image_path
      #p fix_image_name
      #p image_path

      array_fix_image_name = fix_image_name.split('/')

      l = array_fix_image_name.length

      # fix -- remove the name bundle
      remove_name_bundle = array_fix_image_name[l-2]

      #p remove_name_bundle

      new_remove_name_bundle = remove_name_bundle.split("-bundle")



      #p new_remove_name_bundle[0]

      item_h_image_name = array_fix_image_name[l-1]


      #image_new_name
      if item_h_image_name.index("_")

        split_item_h_image_name = item_h_image_name.split("_")

        #image_new_name = split_item_h_image_name[0]+"-"+new_remove_name_bundle[0]+"-h"

        image_new_name = new_remove_name_bundle[0]+"-h"

        p "item name: " +split_item_h_image_name[0]
        p "bundle name: " +new_remove_name_bundle[0]


        #######
        # check if then exist on Item table
        if Item.where(folder_name:split_item_h_image_name[0]).exists?

          # the item exist
          @item = Item.find_by_folder_name(split_item_h_image_name[0])
          p "Item id: "+@item.id.to_s


          bundle_image_name =  new_remove_name_bundle[0]+Image::ImageNameHelper::EXTENSION_JPG
          if Bundle.where(image_name: bundle_image_name).exists?
            # the item exist

            @bundle =  Bundle.find_by_image_name(bundle_image_name)
            p "bundle: "+@bundle.id.to_s

             if ItemsDesign.where(item_id:@item.id,bundle_id:@bundle.id).exists?


                @itemDesign = ItemsDesign.where(item_id:@item.id,bundle_id:@bundle.id).first

                p "itemDesign " + @itemDesign.image_name
                image_new_name = @itemDesign.image_name
                image_new_name = Image::ImageNameHelper.fix_image_name image_new_name
                image_new_name = @item.folder_name+"/"+image_new_name+"-h"+Image::ImageNameHelper::EXTENSION_PNG

                #p app_image_path  + image_new_name
                FileUtils.mkdir_p(app_image_path + @item.folder_name)
             end

            else
              p "Error: the bundle don't exist: "+bundle_image_name
          end
        else
          p "Error: the item don't exist for item: "+split_item_h_image_name[0]
        end
      else

        #image_new_name = item_h_image_name+"-"+new_remove_name_bundle[0]
        image_new_name = new_remove_name_bundle[0]


        p "item name: " +item_h_image_name
        p "bundle name: " +new_remove_name_bundle[0]


        #######
        # check if then exist on Item table
        if Item.where(folder_name:item_h_image_name).exists?

          # the item exist
          @item = Item.find_by_folder_name(item_h_image_name)
          p "Item id: "+@item.id.to_s


          bundle_image_name =  new_remove_name_bundle[0]+Image::ImageNameHelper::EXTENSION_JPG
          if Bundle.where(image_name: bundle_image_name).exists?
            # the item exist

            @bundle =  Bundle.find_by_image_name(bundle_image_name)
            p "bundle: "+@bundle.id.to_s

            if ItemsDesign.where(item_id:@item.id,bundle_id:@bundle.id).exists?


              @itemDesign = ItemsDesign.where(item_id:@item.id,bundle_id:@bundle.id).first

              p "itemDesign " + @itemDesign.image_name
              image_new_name = @item.folder_name+"/"+@itemDesign.image_name
              #image_new_name = Image::ImageNameHelper.fix_image_name image_new_name
              #image_new_name = image_new_name+"-"+Image::ImageNameHelper::EXTENSION_PNG

              #p app_image_path + @item.folder_name
              FileUtils.mkdir_p(app_image_path + @item.folder_name)
            end

          else
            p "Error: the bundle don't exist: "+bundle_image_name
          end
        else
          p "Error: the item don't exist for item: "+item_h_image_name
        end

      end


      #image_new_name = image_new_name +  Image::ImageNameHelper::EXTENSION_PNG


      p app_image_path  + image_new_name
      #p image_new_name
      #p image_path

      #p app_image_path + @item.folder_name.to_s
      #FileUtils.mkdir_p( @item.folder_name)
      #FileUtils.mkpath @item.folder_name
      FileUtils.cp  image_path , app_image_path + image_new_name


    end
  end

  def self.transfer_items_image_300

    Dir["/home/rooms/projects/rails/images/objects300/**/*.jpg"].each do  |image_path|

      app_image_path = "/home/rooms/projects/rails/mywebroom/app/assets/images/items-designs/"
      popthumb = "popthumb"
      thumb = "thumb"

      #p image_path

      fix_image_name = image_path.clone

      ### fix if the image is T.v.
      if fix_image_name.index("T.V.")

        if fix_image_name.index("T.V.300")

          new_fix_image =  fix_image_name.sub("T.V.300x300.jpg","tv300x300.jpg")


          #index_image = fix_image_name.index("T.V.300")
          #fix_image_name[index_image] = "tv300x300.jpg"
          ##fix_image_name[index_image+1] = 'v'
          #fix_image_name[index_image+2] = '_'
          #fix_image_name[index_image+3] = 'h'
          #fix_image_name[index_image+4] = ' '
          #fix_image_name[index_image+5] = ' '
          fix_image_name = new_fix_image
          #p fix_image_name

        else
          index_image = fix_image_name.index("T.V.")
          fix_image_name[index_image] = 't'
          fix_image_name[index_image+1] = 'v'
          fix_image_name[index_image+2] = ' '
          fix_image_name[index_image+3] = ' '
        end
      end

      #coverflow



      fix_image_name = Image::ImageNameHelper.fix_image_name fix_image_name
      #p image_path
      #p fix_image_name
      #p image_path

      array_fix_image_name = fix_image_name.split('/')

      l = array_fix_image_name.length

      # fix -- remove the name bundle
      remove_name_bundle = array_fix_image_name[l-2]

      #p remove_name_bundle

      #new_remove_name_bundle = remove_name_bundle.split("-bundle")
      #new_remove_name_bundle = remove_name_bundle

      #p new_remove_name_bundle[0]

      item_h_image_name = array_fix_image_name[l-1]

      #image_new_name
      if item_h_image_name.index("300x300")

        split_item_h_image_name = item_h_image_name.split("300x300")

        image_new_name = split_item_h_image_name[0]+"-"+array_fix_image_name[l-2]+"-300x300"



        #image_new_name = new_remove_name_bundle[0]+"-h"

        p "item name: " +split_item_h_image_name[0]
        #p "bundle name: " +new_remove_name_bundle[0]


        #######
        # check if then exist on Item table
        if Item.where(folder_name:split_item_h_image_name[0]).exists?

          # the item exist
          @item = Item.find_by_folder_name(split_item_h_image_name[0])
          p "Item id: "+@item.id.to_s


          bundle_image_name =  array_fix_image_name[l-2]+Image::ImageNameHelper::EXTENSION_JPG
          if Bundle.where(image_name: bundle_image_name).exists?
            # the item exist

            @bundle =  Bundle.find_by_image_name(bundle_image_name)
            p "bundle: "+@bundle.id.to_s

            if ItemsDesign.where(item_id:@item.id,bundle_id:@bundle.id).exists?


              @itemDesign = ItemsDesign.where(item_id:@item.id,bundle_id:@bundle.id).first

              p "itemDesign " + @itemDesign.image_name
              image_new_name = @itemDesign.image_name
              image_new_name = Image::ImageNameHelper.fix_image_name image_new_name
              image_new_name = @item.folder_name+"/"+image_new_name+"-300x300"+Image::ImageNameHelper::EXTENSION_JPG

              p app_image_path  + image_new_name
            end

          else
            p "Error: the bundle don't exist: "+bundle_image_name
          end
        else
          p "Error: the item don't exist for item: "+split_item_h_image_name[0]
        end

      else
        #image_new_name = item_h_image_name+"-"+new_remove_name_bundle[0]
      end

      #image_new_name = image_new_name +  Image::ImageNameHelper::EXTENSION_JPG


      p app_image_path + image_new_name
      #p image_new_name
      p image_path

      FileUtils.cp  image_path , app_image_path + image_new_name


    end
  end

end