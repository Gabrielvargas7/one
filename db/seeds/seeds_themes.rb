module SeedThemesModule



  def self.InsertThemes(ws)
    Theme.delete_all
    ## insert the Themes Table
    for row in 1..ws.num_rows

      if ws[row,1]!='theme_id'

        image_name = Image::ImageNameHelper.fix_image_name ws[row,4]

        image_popthumb = Dir.pwd+"/db/seeds/images/themes/"+image_name+"-popthumb"+Image::ImageNameHelper::EXTENSION_JPG

        image_name = image_name+Image::ImageNameHelper::EXTENSION_JPG

        image_name = Dir.pwd+"/db/seeds/images/themes/"+image_name


        p "Inserting Theme "+ws[row,1] +" name: "+ ws[row,2] +" image_name: "+image_name

        b = Theme.new(name:ws[row,2], description: ws[row, 3])
        b.id = ws[row,1]

        if File.exists?(image_name)
          b.image_name = File.open(image_name)

          else
            p "Error: No themes images:"+image_name
        end

        if File.exists?(image_popthumb)
          b.image_name_selection = File.open(image_popthumb)

        else
          p "Error: No themes images:"+image_popthumb
        end


        #if Theme.where(image_name: image_name).exists?
        #  # the image name exist
        #  p "Error: the theme image name already exist on themes:"+image_name
        #  b.image_name = -1
        #else
        #  b.image_name = image_name
        #end
        #

        b.save
      end


      #pi = ProductImage.create!(:product => product)
      #pi.image.store!(File.open(File.join(Rails.root, 'test.jpg')))
      #product.product_images << pi
      #product.save!
      #

      #pi = ThemesImageUploader.create!(:product => product)
      #pi.image.store!(File.open(File.join(Rails.root, 'test.jpg')))
      #product.product_images << pi
      #product.save!

    end
  end

end