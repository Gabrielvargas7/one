module SeedItemsModule

  def self.InsertItems(ws)
  Item.delete_all
    # insert the Items Table
    for row in 1..ws.num_rows
      if ws[row,1]!='item_id'

        # create image name with two values (imagename)

        folder_name = Image::ImageNameHelper.fix_image_name ws[row,9]
        #image_name = image_name+Image::ImageNameHelper::EXTENSION_PNG


        p "Inserting Item "+ws[row,1] +" name: "+ ws[row,2]+" folder name"+folder_name
        b = Item.new(name:ws[row,2],x:ws[row,3],y:ws[row,4],z:ws[row,5],width:ws[row,6],height:ws[row,7])

        clickable = ws[row,8]
        clickable.downcase!

        b.clickable = clickable

        b.id = ws[row, 1]

        if Item.where(folder_name: folder_name).exists?
          # the item exist
          p "Error: the item image name already exist on the item table "+folder_name
           b.folder_name = -1
        else
           b.folder_name = folder_name

        end

        b.save
      end
    end

  end

  def self.InsertItemsDesign(ws)
  ItemsDesign.delete_all
    # insert the Items_designs Table
    for row in 1..ws.num_rows
      if ws[row,1]!='id'

          item_folder_name = Image::ImageNameHelper.fix_image_name ws[row,5]
          item_design_name = Image::ImageNameHelper.fix_image_name ws[row,6]

          item_design_id = Image::ImageNameHelper.fix_image_name ws[row,1]
          # create image name with two values (itemNames-itemDesignName-id)
          image_name =  item_design_name+"-"+item_design_id+Image::ImageNameHelper::EXTENSION_PNG
          image_name_hover =  item_design_name+"-"+item_design_id+"-h"+Image::ImageNameHelper::EXTENSION_PNG
          image_name_pick =  item_design_name+"-"+item_design_id+"-300x300"+Image::ImageNameHelper::EXTENSION_JPG

          #image_name = item_design_name+Image::ImageNameHelper::EXTENSION_PNG
          image_already_on_ImageDesign_db = ItemsDesign.find_by_image_name(image_name)

          # add extension
          #item_image_name  = item_image_name+Image::ImageNameHelper::EXTENSION_PNG
          image_name_folder = Dir.pwd+"/db/seeds/images/items-designs/"



          #if image_already_on_ImageDesign_db.blank?

            #p "Inserting Item design: "+ws[row,1] +" name: "+ ws[row,3]+" image_name: "+image_name+ " items name:"+item_folder_name

            itemsDesign = ItemsDesign.new(name:ws[row,3],description:ws[row,4])


            #itemsDesign.image_name = image_name

            # check if then exist on Item table

             p "Inserting Item design: "+ws[row,1] +" name: "+ ws[row,3]+" image_name: "+image_name+ " items name:"+item_folder_name

             if Item.where(folder_name: item_folder_name).exists?
                 # the item exist
                items = Item.find_by_folder_name(item_folder_name)
                itemsDesign.item_id = items.id
                image_name = image_name_folder+items.folder_name+"/"+image_name

                image_name_hover = image_name_folder+items.folder_name+"/"+image_name_hover

                image_name_pick = image_name_folder+items.folder_name+"/"+image_name_pick

                #p image_name
                #p image_name_hover
                #p image_name_pick

                # main image
                if File.exists?(image_name)
                  itemsDesign.image_name = File.open(image_name)
                  p "main image:" +image_name

                else
                  p "Error: No Items-design images:"+image_name
                end

                # hover image image
                if File.exists?(image_name_hover)
                  itemsDesign.image_name_hover = File.open(image_name_hover)
                  p "Hover image: " +image_name_hover

                else
                  p "Error: Hover - No Items-design images:"+image_name_hover
                end

                # hover small image 300x300
                if File.exists?(image_name_pick)
                  itemsDesign.image_name_selection = File.open(image_name_pick)
                  p "pick image: "+image_name_pick

                else
                  p "Error: Small- No Items-design images:"+image_name_pick
                end



             else
                 p "Error: the item don't exist for the item id:"+item_folder_name
                 itemsDesign.item_id = -1
              end

            #check if bundle exist on bundle table
            if Bundle.exists?(ws[row,2])
              # the item don't exist
              bundle = Bundle.find(ws[row,2])
              itemsDesign.bundle_id = bundle.id;
            else
              if ws[row,2] = 0
                p "General Object not belong to any bundle-> bundle Id "+ws[row,2]
                itemsDesign.bundle_id = 0
              else
                p "Error: the bundle don't exist for the bundle Id "+ws[row,2]
                itemsDesign.bundle_id = -1
              end
            end

              itemsDesign.id = ws[row, 1]
              itemsDesign.save
          #else
          #  p "Name Already Take it "+ws[row,1] +" name: "+ ws[row,3]+" image_name "+image_name
          #end
      end
    end

  end

end


