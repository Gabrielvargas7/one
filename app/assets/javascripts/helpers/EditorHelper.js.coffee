Mywebroom.Helpers.Editor = {
  
  paginateInitial: (type, limit, offset) ->
    
    
    switch type
    
    
    
    
      when "THEMES"
      
        Themes = new Mywebroom.Collections.IndexThemesByLimitAndOffsetCollection([], {limit: limit, offset: offset})
        Themes.fetch({
          async: false
          success: (collection, response, options) ->
            #console.log("themes fetch success", collection)
            
          error: (collection, response, options) ->
            console.error("themes fetch fail", response.responseText)
        })
        
        return Themes
      
      
      
      
      
      
      when "BUNDLES"
      
        Bundles = new Mywebroom.Collections.IndexBundlesByLimitAndOffsetCollection([], {limit: limit, offset: offset})
        Bundles.fetch({
          async: false
          success: (collection, response, options) ->
            #console.log("bundles fetch success", collection)
          
          error: (collection, response, options) ->
            console.error("bundles fetch fail", response.responseText)
        })
        
        return Bundles
      
      
      
      
      
      when "ENTIRE ROOMS"
      
        EntireRooms = new Mywebroom.Collections.IndexEntireRoomsByLimitAndOffsetCollection([], {limit: limit, offset: offset})
        EntireRooms.fetch({
          async: false
          success: (collection, response, options) ->
            #console.log("entire rooms fetch success", collection)
          
          error: (collection, response, options) ->
            console.error("entire rooms fetch fail", response.responseText)
        })
        
        return EntireRooms
      
      
      
      
      else
        
        
        
        Designs = new Mywebroom.Collections.IndexEntireRoomsByLimitAndOffsetCollection([], {item_id: type, limit: limit, offset: offset})
        Designs.fetch({
          async: false
          success: (collection, response, options) ->
            #console.log("designs fetch success", collection)
          
          error: (collection, response, options) ->
            console.error("designs fetch fail", response.responseText)
        })
        
        return Designs
        
}
