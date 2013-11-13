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



        Designs = new Mywebroom.Collections.IndexItemsDesignsByItemIdAndLimitOffsetCollection([], {item_id: type, limit: limit, offset: offset})
        Designs.fetch({
          async: false
          success: (collection, response, options) ->
            #console.log("designs fetch success", collection)

          error: (collection, response, options) ->
            console.error("designs fetch fail", response.responseText)
        })

        return Designs










  paginateSearch: (type, limit, offset, keyword) ->

    switch type
      when "ALL"
        ###
        Fetch designs collection
        ###
        designs = new Mywebroom.Collections.IndexSearchesItemsDesignsWithLimitAndOffsetAndKeywordCollection()
        designs.fetch
          async: false
          url: designs.url(limit, offset, keyword)
          success: (collection, response, options) ->
            #console.log(collection.length + " designs found! <-- ALL")

          error: (collection, response, options) ->
            console.error("search all: designs fetch fail", response.responseText)


        ###
        Fetch themes collection
        ###
        themes = new Mywebroom.Collections.IndexSearchesThemesWithLimitAndOffsetAndKeywordCollection()
        themes.fetch
          async: false
          url: themes.url(limit, offset, keyword)
          success: (collection, response, options) ->
            #console.log(collection.length + " themes found! <-- ALL")

          error: ->
            console.error("search all: themes fetch fail", response.responseText)


        ###
        Fetch bundles collection
        ###
        bundles = new Mywebroom.Collections.IndexSearchesBundlesWithLimitAndOffsetAndKeywordCollection()
        bundles.fetch
          async: false
          url: bundles.url(limit, offset, keyword)
          success: (collection, response, options) ->
            #console.log(collection.length + " bundles found! <-- ALL")

          error: (collection, response, options) ->
            console.error("search all: bundles fetch fail", response.responseText)



        ###
        Fetch entire rooms collection
        ###
        entireRooms = new Mywebroom.Collections.IndexSearchesBundlesWithLimitAndOffsetAndKeywordCollection()
        entireRooms.fetch
          async: false
          url: entireRooms.url(limit, offset, keyword)
          success: (collection, response, options) ->
            #console.log(collection.length + " entire rooms found! <-- ALL")

          error: (collection, response, options) ->
            console.error("search all: entire rooms fetch fail", response.responseText)


        ###
        This is a bundles collection, but we're going to use it as a collection of
        entire room objects. This means we need to override it's type property.

        Note that since this mapping is being done outside of the collection's parse
        method, we need to reset our collection with the model data after mapping.
        http://stackoverflow.com/questions/17034593/how-does-map-work-with-a-backbone-collection
        ###

        # Override the type property
        parsed = entireRooms.map((model) ->
          obj = model
          obj.set("type", "ENTIRE_ROOM")
          return obj
        )

        # Reset the collection
        reset = entireRooms.reset(parsed)
        #console.log("searched entire rooms II success", reset)


        ###
        NOW COMBINE ALL THE COLLECTIONS
        ###
        data = designs.toJSON().concat(themes.toJSON()).concat(bundles.toJSON()).concat(reset.toJSON())
        everything = new Backbone.Collection(data)


        #console.log(everything.length + " total things found! <-- ALL")


        #console.log("everything", everything)


        # Now splat it to the screen
        return everything






      when "OBJECTS"
        ###
        Fetch collection
        ###
        collection = new Mywebroom.Collections.IndexSearchesItemsDesignsWithLimitAndOffsetAndKeywordCollection()
        collection.fetch
          async  : false
          url    : collection.url(limit, offset, keyword)
          success: (collection, response, options) ->
            #console.log(collection.length + " designs found!")

          error: (collection, response, options) ->
            console.error("search objects fetch fail", response.responseText)


        return collection







      when "THEMES"
        ###
        Fetch collection
        ###
        collection = new Mywebroom.Collections.IndexSearchesThemesWithLimitAndOffsetAndKeywordCollection()
        collection.fetch
          async: false
          url: collection.url(limit, offset, keyword)
          success: (collection, response, options) ->
            #console.log(collection.length + " themes found!")

          error: (collection, response, options) ->
            console.error("search themes fetch fail", response.responseText)


        return collection





      when "BUNDLES"
        ###
        Fetch collection
        ###
        collection = new Mywebroom.Collections.IndexSearchesBundlesWithLimitAndOffsetAndKeywordCollection()
        collection.fetch
          async: false
          url: collection.url(limit, offset, keyword)
          success: (collection, response, options) ->
            #console.log(collection.length + " bundles found!")

          error: (collection, response, options) ->
            console.error("search bundles fetch fail", response.responseText)

        return collection








      when "ENTIRE ROOMS"
        ###
        Fetch collection
        ###
        collection = new Mywebroom.Collections.IndexSearchesBundlesWithLimitAndOffsetAndKeywordCollection()
        collection.fetch
          async  : false
          url    : collection.url(limit, offset, keyword)
          success: (collection, response, options) ->
            #console.log(collection.length + " entire rooms found!")

          error: (collection, response, options) ->
            console.error("search entire rooms fetch fail", response.responseText)


        ###
        This is a bundles collection, but we're going to use it as a collection of
        entire room objects. This means we need to override it's type property.

        Note that since this mapping is being done outside of the collection's parse
        method, we need to reset our collection with the model data after mapping.
        http://stackoverflow.com/questions/17034593/how-does-map-work-with-a-backbone-collection
        ###

        # Override the type property
        parsed = collection.map((model) ->
          obj = model
          obj.set("type", "ENTIRE_ROOM")
          return obj
        )

        # Reset the collection
        reset = collection.reset(parsed)

        #console.log(reset.length + " entire rooms found! (after parse)")

        return reset







      else
        ###
        Looks like it's a specific design category (number)
        ###

        #console.log("YOU'RE SEARCHING ON ITEM DESIGN CATEGORY ", category)

        ###
        Fetch collection
        ###
        collection = new Mywebroom.Collections.IndexSearchesItemsDesignsWithItemIdAndLimitAndOffsetAndKeywordCollection()
        collection.fetch
          async:   false
          url:     collection.url(type, limit, offset, keyword)
          success: (collection, response, options) ->
            #console.log(collection.length + " designs found!")

          error: (collection, response, options) ->
            console.error("search designs fetch fail", response.responseText)



        return collection











  appendCollection: (collection, type) ->


    #console.log('appendCollection')


    switch type

      when 'ITEMS'

        tab_id = '#tab_items'
        row_id = 'row_item_'
        social = false

      when 'THEMES'

        tab_id = '#tab_themes'
        row_id = 'row_theme_'
        social = true

      when 'BUNDLES'

        tab_id = '#tab_bundles'
        row_id = 'row_bundle_'
        social = true

      when 'ENTIRE ROOMS'

        tab_id = '#tab_entire_rooms'
        row_id = 'row_bundle_set_'
        social = true

      when 'HIDDEN'

        tab_id = '#tab_hidden'
        row_id = 'row_item_designs_'
        social = true








    $(tab_id + ' > ul').remove()

    loop_number =   0
    row_number =    1
    column_number = 3

    row_line = "<ul id=" + row_id + "1></ul>"
    $(tab_id).append(row_line)


    collection.each (model) ->
      view = new Mywebroom.Views.StorePreviewView({model: model})
      $('#' + row_id + row_number).append(view.el)
      view.render()


      if social then view.addSocialView()


      loop_number += 1
      u = loop_number % column_number

      if u is 0
        row_number += 1
        row_line = "<ul id=" + row_id + row_number + "></ul>"
        $(tab_id).append(row_line)







  showItem: (num) ->


    ###
    Takes the id of an item. This corresponds to the item_id of a design.
    We then do 3 things:

    (1) Switch to the 'hidden' tab
    (2) Look up all the models associated with this id
    (3) Render a view for ea. of the models to the display area

    Note: we don't need to add social views when we're in the tutorial
    ###



}
