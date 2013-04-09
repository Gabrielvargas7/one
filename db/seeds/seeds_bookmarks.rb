module SeedBookmarkModule

  #require_relative '../../app/helpers/images/Image_helper'

   def self.InsertBookmarkCategory(ws)

      # insert the Bookmark Category Table
      for row in 1..ws.num_rows
        if ws[row,1]!='id'


          item_image_name = ImageNameHelper.fix_image_name ws[row,2]

          p "Inserting Bookmark Category Id "+ws[row,1] +" name: "+ ws[row,3]+" item name  "+item_image_name
          b = BookmarksCategory(name:ws[row,3])
          b.id = ws[row, 1]

          ##
          if Item.where(image_name: item_image_name).exists?
            # the item exist
            items = Item.find_by_image_name(item_image_name)
            itemsDesign.item_id = items.id
          else
            p "Error: the item don't exist for the image:"+item_image_name
            itemsDesign.item_id = -1
          end

          b.save
        end
      end



   end
end
