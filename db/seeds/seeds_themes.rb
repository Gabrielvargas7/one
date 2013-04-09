module SeedThemesModule

  #require_relative '../../app/helpers/images/Image_helper'

  def self.InsertThemes(ws)
    ## insert the Themes Table
    for row in 1..ws.num_rows

      if ws[row,1]!='theme_id'

        image_name = ImageNameHelper.fix_image_name ws[row,4]
        p "Inserting Theme "+ws[row,1] +" name: "+ ws[row,2] +" image_name: "+image_name
        b = Theme.new(name:ws[row,2], description: ws[row, 3],image_name:image_name)
        b.id = ws[row,1]
        b.save
      end
    end
  end

end