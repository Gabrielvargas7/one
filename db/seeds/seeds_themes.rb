module SeedThemesModule



  def self.InsertThemes(ws)
    ## insert the Themes Table
    for row in 1..ws.num_rows

      if ws[row,1]!='theme_id'

        image_name = Image::ImageNameHelper.fix_image_name ws[row,4]
        image_name = image_name+Image::ImageNameHelper::EXTENSION_JPG
        p "Inserting Theme "+ws[row,1] +" name: "+ ws[row,2] +" image_name: "+image_name
        b = Theme.new(name:ws[row,2], description: ws[row, 3])
        b.id = ws[row,1]

        if Theme.where(image_name: image_name).exists?
          # the image name exist
          p "Error: the theme image name already exist on themes:"+image_name
          b.image_name = -1
        else
          b.image_name = image_name

        end



        b.save
      end
    end
  end

end