module SeedBookmarkModule


   def self.InsertBookmarkCategory(ws)
      BookmarksCategory.delete_all
      # insert the Bookmark Category Table
      for row in 1..ws.num_rows
        if ws[row,1]!='id'

          item_folder_name = Image::ImageNameHelper.fix_image_name ws[row,2]
          #item_image_name = item_image_name+Image::ImageNameHelper::EXTENSION_PNG


          p "Inserting Bookmark Category Id "+ws[row,1] +" name: "+ ws[row,3]+" item image name:  "+item_folder_name
          b = BookmarksCategory.new(name:ws[row,3])
          b.id = ws[row, 1]

          if Item.where(folder_name: item_folder_name).exists?
            # the item exist
            item  = Item.find_by_folder_name(item_folder_name)
            b.item_id = item.id;
          else
            p "Error: the item image name don't exist on  the table item:"+item_folder_name
            b.item_id  = -1
          end
          b.save
        end
      end
   end

   def self.InsertBookmarks(ws)
     Bookmark.delete_all
     # insert the Bookmark Table
     for row in 1..ws.num_rows

       if ( ws[row,1].blank? ||
           ws[row,2].blank? ||
           ws[row,3].blank? ||
           ws[row,4].blank? ||
           ws[row,5].blank? ||
           ws[row,6].blank?)

           p "-----Error: some data are blank:  "
           p " ---- Item name: "+ ws[row,1] + " image-name: "+ ws[row,2] +" Id: "+ ws[row,3]+" url: "+ ws[row,4]+" title: "+ ws[row,5]+" I-frame: "+ ws[row,6]

        else

          if ws[row,3]!='id'

             #get the image name of the item
             item_folder_name = Image::ImageNameHelper.fix_image_name ws[row,1]
             #item_image_name = item_image_name+Image::ImageNameHelper::EXTENSION_PNG
             bookmark_image_name = Image::ImageNameHelper.fix_image_name ws[row,2]
             bookmark_image_name = bookmark_image_name + Image::ImageNameHelper::EXTENSION_PNG

             image_name_folder = Dir.pwd+"/db/seeds/images/bookmarks/"

             p "Inserting Bookmark Id "+ws[row,3] +" title: "+ ws[row,5]+" image name: "+bookmark_image_name

             b = Bookmark.new()


             if Item.where(folder_name: item_folder_name).exists?
               # the item exist
               items = Item.find_by_folder_name(item_folder_name)


               image_name = image_name_folder+items.folder_name+"/"+bookmark_image_name


               p image_name

               # main image
               if File.exists?(image_name)
                b.image_name = File.open(image_name)
                 p "bookmark image:" +image_name

               else
                 p "Error: No Bookmarks images:"+image_name
               end
            end


             b.id = ws[row,3]
             b.bookmark_url = ws[row,4]
             b.title = ws[row,5]
             b.i_frame= ws[row,6]

             # the image_name_desc can be nil
             if ws[row,8].blank?
               p "Warning: the image_name_desc is empty, bookmark id: "+ws[row,3]
               b.image_name_desc
             else
               image_name_dec = Image::ImageNameHelper.fix_image_name ws[row,8]
               b.image_name_desc = image_name_dec+Image::ImageNameHelper::EXTENSION_PNG
             end

             if ws[row,9].blank?
               p "Warning: the description is empty, bookmark id: "+ws[row,3]
             else
               b.description = ws[row,9]
             end

             #validate bookmark category
             if BookmarksCategory.where(id: ws[row,7]).exists?
               # the BookmarkCategory exist
               b.bookmarks_category_id = ws[row,7]
             else
               p "Warning: the Bookmark category don't exist on the table bookmark category: "+ws[row,7]
             end
             #validate Items
             if Item.where(folder_name: item_folder_name).exists?
               # the item exist
               item  = Item.find_by_folder_name(item_folder_name)
               b.item_id = item.id;
             else
               p "Error: the item image name don't exist on  the table item:"+item_folder_name
               b.item_id  = -1
             end
             b.save

           end
        end




     end
   end


end
