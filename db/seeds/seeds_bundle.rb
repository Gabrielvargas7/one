module SeedBundleModule

  #require_relative '../../app/helpers/images/Image_helper'

    def self.InsertBundles(ws)
    # insert the bundles Table
      for row in 1..ws.num_rows
        if ws[row,1]!='bundle_id'

          image_name = ImageNameHelper.fix_image_name ws[row,5]

          p "Inserting Bundle "+ws[row,1] +" name: "+ ws[row,3] +" image_name: "+image_name
          b = Bundle.new(name:ws[row,3], description: ws[row, 4],image_name: image_name)
          b.theme_id = ws[row, 2]

          b.id = ws[row, 1]
          b.save
        end
      end
    end
end