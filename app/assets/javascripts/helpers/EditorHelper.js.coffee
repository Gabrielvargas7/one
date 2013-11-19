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

        if Themes.length < Mywebroom.Data.Editor.limit
          Mywebroom.Data.Editor.paginate = false

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

        if Bundles.length < Mywebroom.Data.Editor.limit
          Mywebroom.Data.Editor.paginate = false

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

        if EntireRooms.length < Mywebroom.Data.Editor.limit
          Mywebroom.Data.Editor.paginate = false

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

        if Designs.length < Mywebroom.Data.Editor.limit
          Mywebroom.Data.Editor.paginate = false

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
        if everything.length < Mywebroom.Data.Editor.limit
          Mywebroom.Data.Editor.paginate = false

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


        if collection.length < Mywebroom.Data.Editor.limit
          Mywebroom.Data.Editor.paginate = false

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


        if collection.length < Mywebroom.Data.Editor.limit
          Mywebroom.Data.Editor.paginate = false

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


        if collection.length < Mywebroom.Data.Editor.limit
          Mywebroom.Data.Editor.paginate = false

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

        if reset.length < Mywebroom.Data.Editor.limit
          Mywebroom.Data.Editor.paginate = false

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


        if collection.length < Mywebroom.Data.Editor.limit
          Mywebroom.Data.Editor.paginate = false

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

    row_line = "<ul id=" + row_id + "1 class=editor-tab-content></ul>"
    $(tab_id).append(row_line)


    collection.each (model) ->
      view = new Mywebroom.Views.StorePreviewView({model: model})
      view.render()

      $('#' + row_id + row_number).append(view.el)




      if social then view.addSocialView()


      loop_number += 1
      u = loop_number % column_number

      if u is 0
        row_number += 1
        row_line = "<ul id=" + row_id + row_number + " class=editor-tab-content></ul>"
        $(tab_id).append(row_line)





  clickItem: (itemId) ->


    #console.log("click item")

    ###
    (0) Pagination
    (1) Change to hidden tab
    (2) Conditionally show remove button
    (3) Conditionally highlight room item
    (4) Fetch corresponding designs
    (5) Update views
    (6) Center item
    (7) Update filters
    ###


    # Pagination
    Mywebroom.Data.Editor.paginate = true
    Mywebroom.Data.Editor.contentPath = "INITIAL"
    Mywebroom.Data.Editor.offset = 0



    # Switch to the hidden tab
    $('#storeTabs a[href="#tab_hidden"]').tab('show')





    Mywebroom.Data.Editor.contentType = itemId



    ###
    Set our store helper
    ###
    Mywebroom.State.set("storeHelper", itemId)



    ###
    Find the design that was clicked and
    create a reference to it's container element
    ###
    $activeDesign = $("[data-design-item-id=" + itemId + "]")


    # Save this object to our state model
    Mywebroom.State.set("$activeDesign", $activeDesign)




    # Show the Save, Cancel, Remove view and remove button
    # iff the object design's roomHide property is "no"
    if $activeDesign.attr("data-room-hide")  is "no"
      # Show the Save, Cancel, Remove view
      $("#xroom_store_menu_save_cancel_remove").show()


      # SET STATE OF SAVE, CANCEL, REMOVE BUTTONS
      # Hide the save button
      $('#xroom_store_save').hide()

      # Hide the cancel button
      $('#xroom_store_cancel').hide()

      # Show the remove button
      $('#xroom_store_remove').show()


      ###
      Highlight Image
      ###
      Mywebroom.Helpers.highLight(itemId)

    else
      # Show the Save, Cancel, Remove view
      $("#xroom_store_menu_save_cancel_remove").hide()


      # SET STATE OF SAVE, CANCEL, REMOVE BUTTONS
      # Hide the save button
      $('#xroom_store_save').hide()

      # Hide the cancel button
      $('#xroom_store_cancel').hide()

      # Hide the remove button
      $('#xroom_store_remove').hide()





    ###
    FETCH CORRESPONDING DESIGNS
    ###
    designs = Mywebroom.Helpers.Editor.paginateInitial(itemId, 10, 0)




    ###
    UPDATE VIEWS
    ###
    Mywebroom.State.set('tabContentHidden', designs)





    ###
    CENTER ITEM
    ###
    Mywebroom.Helpers.centerItem(itemId)




    ###
    FILTERS - START
    ###
    # Show all the dropdown filters
    Mywebroom.Helpers.expandFilters()


    # Collapse location filter
    $('#dropdown-location').addClass('collapse')


    # Populate the filters
    categories = new Mywebroom.Collections.IndexItemsDesignsCategoriesByItemIdCollection()
    categories.fetch
      async  : false
      url    : categories.url itemId
      success: (response) ->
        #console.log("designs fetch success", response)
        myModel = categories.first()
        Mywebroom.Helpers.setCategories(myModel.get('items_designs_categories'))
        Mywebroom.Helpers.setBrands(myModel.get('items_designs_brands'))
        Mywebroom.Helpers.setStyles(myModel.get('items_designs_styles'))
        Mywebroom.Helpers.setColors(myModel.get('items_designs_colors'))
        Mywebroom.Helpers.setMakes(myModel.get('items_designs_makes'))
    ###
    FILTERS - END
    ###
}
