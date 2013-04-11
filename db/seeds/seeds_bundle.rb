module SeedBundleModule

    def self.InsertBundles(ws)
    # insert the bundles Table
      for row in 1..ws.num_rows
        if ws[row,1]!='bundle_id'

          image_name = Image::ImageNameHelper.fix_image_name ws[row,5]

          image_name = image_name+Image::ImageNameHelper::EXTENSION_JPG

          p "Inserting Bundle "+ws[row,1] +" name: "+ ws[row,3] +" image_name: "+image_name
          b = Bundle.new(name:ws[row,3], description: ws[row, 4])
          b.theme_id = ws[row, 2]

          if Bundle.where(image_name: image_name).exists?
            # the item exist
            p "Error: the bundle image name already exist on the bundle table "+image_name
            b.image_name = -1
          else
            b.image_name = image_name
          end


          b.id = ws[row, 1]
          b.save
        end
      end
    end

    def self.InsertBundlesBookmarks(ws)
      # insert the bundles Table
      for row in 1..ws.num_rows
        if ws[row,1]!='item_image_name'

          image_name = Image::ImageNameHelper.fix_image_name ws[row,1]

          image_name = image_name+Image::ImageNameHelper::EXTENSION_PNG

          p "Inserting Bundle Bookmark: bookmark title: "+ws[row,2] +" bookmark_id: "+ ws[row,3] +" item image_name: "+image_name
          b = BundlesBookmark.new()

          if Bookmark.where(id:ws[row, 3]).exists?
            b.bookmark_id = ws[row, 3]
          else
            p "Error: the Bookmark Id don't exist "+ws[row, 3]
          end

          # check if then exist on Item table
          if Item.where(image_name:image_name).exists?
            # the item exist
            items = Item.find_by_image_name(image_name)
            b.item_id = items.id
          else
            p "Error: the item don't exist for the image: "+image_name
            b.item_id = -1
          end
          b.save
        end
      end
    end


end