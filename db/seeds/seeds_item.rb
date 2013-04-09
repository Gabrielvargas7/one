module SeedItemsModule

  def self.InsertItems(ws)
  Item.delete_all
    # insert the Items Table
    for row in 1..ws.num_rows
      if ws[row,1]!='item_id'

        # create image name with two values (imagename)
        image_name = ImageNameHelper.fix_image_name ws[row,9]


        p "Inserting Item "+ws[row,1] +" name: "+ ws[row,2]+" image_name "+image_name
        b = Item.new(name:ws[row,2],x:ws[row,3],y:ws[row,4],z:ws[row,5],width:ws[row,6],height:ws[row,7],clickable:ws[row,8])
        b.id = ws[row, 1]

        if Item.where(image_name: image_name).exists?
          # the item exist
          p "Error: the item don't exist for the image:"+image_name
           b.image_name = -1
        else
           b.image_name = image_name

        end

        b.save
      end
    end

  end

  def self.InsertItemsDesign(ws)
  ItemsDesign.delete_all
    ## insert the Items_designs Table
    for row in 1..ws.num_rows
      if ws[row,1]!='id'

          item_image_name = ImageNameHelper.fix_image_name ws[row,5]
          item_design_name = ImageNameHelper.fix_image_name ws[row,6]

          # create image name with two values (itemNames-itemDesignName-id)
          image_name =  item_image_name+"-"+ item_design_name
          image_already_on_ImageDesign_db = ItemsDesign.find_by_image_name(image_name)

          if image_already_on_ImageDesign_db.blank?

            p "Inserting Item design"+ws[row,1] +" name: "+ ws[row,3]+" image_name "+image_name

            itemsDesign = ItemsDesign.new(name:ws[row,3],description:ws[row,4],image_name:image_name)

            # check if then exist on Item table
              if Item.where(:image_name=> item_image_name).exists?
                 # the item exist
                items = Item.find_by_image_name(item_image_name)
                itemsDesign.item_id = items.id
              else
                 p "Error: the item don't exist for the image:"+item_image_name
                 itemsDesign.item_id = -1
              end

            # check if bundle exist on bundle table

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
          else
            p "Name Already Take it "+ws[row,1] +" name: "+ ws[row,3]+" image_name "+image_name
          end
      end
    end

  end

end


