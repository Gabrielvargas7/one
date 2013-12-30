Mywebroom.Helpers.EditorHelper = {


  onEditorScroll: ->

    ###
    Here, we setup a scroll handler for the editor.
    We trigger actions when the page is scrolled to the bottom.
    ###
    $(".tab-content").on "mousewheel",
      mousewheel:
        behavior: "throttle"
        delay: 100
      , (event) ->

        if event.deltaY > 0

          # ARE WE AT THE BOTTOM?
          if $('.tab-content').scrollTop() + $('.tab-content').innerHeight() >= $('.tab-content')[0].scrollHeight - 300


            ###
            FIX for Safari 6 on iMac
            Issue: pagination causes editor to scroll to top
            ###
            Mywebroom.Data.Editor.location = $('.tab-content').scrollTop()


            # IS PAGINATE TRUE?
            if Mywebroom.Data.Editor.paginate is true

              #console.log("paginate")

              path =    Mywebroom.Data.Editor.contentPath
              type =    Mywebroom.Data.Editor.contentType
              keyword = Mywebroom.Data.Editor.keyword
              limit =   Mywebroom.Data.Editor.limit
              offset  = Mywebroom.Data.Editor.offset + limit


              if path is false then console.error("no pagination type!")




              switch path

                when "INITIAL"

                  #console.log("PAGINATE INITIAL - " + type + "\tOffset: " + offset)

                  data = Mywebroom.Helpers.EditorHelper.paginateInitial(type, limit, offset)
                  #console.log(data.length)

                  unless data.length is 0

                    switch type

                      when "THEMES"

                        col = Mywebroom.State.get('tabContentThemes')
                        #console.log('initial length', col.length)

                        col.add(data.toJSON(), {silent: false})
                        #console.log('length after add', col.length)

                        Mywebroom.State.set('tabContentThemes', col)
                        Mywebroom.Helpers.EditorHelper.appendCollection(col, 'THEMES')

                      when "BUNDLES"

                        col = Mywebroom.State.get('tabContentBundles')
                        #console.log('initial length', col.length)

                        col.add(data.toJSON(), {silent: false})
                        #console.log('length after add', col.length)


                        Mywebroom.State.set('tabContentBundles', col)
                        Mywebroom.Helpers.EditorHelper.appendCollection(col, 'BUNLDES')

                      when "ENTIRE ROOMS"

                        col = Mywebroom.State.get('tabContentEntireRooms')
                        #console.log('initial length', col.length)

                        col.add(data.toJSON(), {silent: false})
                        #console.log('length after add', col.length)


                        Mywebroom.State.set('tabContentEntireRooms', col)
                        Mywebroom.Helpers.EditorHelper.appendCollection(col, 'ENTIRE ROOMS')

                      else

                        col = Mywebroom.State.get('tabContentHidden')
                        #console.log('initial length', col.length)

                        col.add(data.toJSON(), {silent: false})
                        #console.log('length after add', col.length)


                        Mywebroom.State.set('tabContentHidden', col)
                        Mywebroom.Helpers.EditorHelper.appendCollection(col, 'HIDDEN')


                    Mywebroom.Data.Editor.offset += limit


                when "SEARCH"

                  #console.log("PAGINATE SEARCH - " + type + "\tOffset: " + offset + "\tKeyword: " + keyword)

                  data = Mywebroom.Helpers.EditorHelper.paginateSearch(type, limit, offset, keyword)
                  #console.log(data.length)


                  unless data.length is 0

                    switch type

                      when "THEMES"

                        col = Mywebroom.State.get('tabContentThemes')
                        col.add(data.toJSON(), {silent: false})
                        Mywebroom.State.set('tabContentThemes', col)
                        Mywebroom.Helpers.EditorHelper.appendCollection(col, 'THEMES')

                      when "BUNDLES"

                        col = Mywebroom.State.get('tabContentBundles')
                        col.add(data.toJSON(), {silent: false})
                        Mywebroom.State.set('tabContentBundles', col)
                        Mywebroom.Helpers.EditorHelper.appendCollection(col, 'BUNDLES')

                      when "ENTIRE ROOMS"

                        col = Mywebroom.State.get('tabContentEntireRooms')
                        col.add(data.toJSON(), {silent: false})
                        Mywebroom.State.set('tabContentEntireRooms', col)
                        Mywebroom.Helpers.EditorHelper.appendCollection(col, 'ENTIRE ROOMS')

                      else

                        col = Mywebroom.State.get('tabContentHidden')
                        col.add(data.toJSON(), {silent: false})
                        Mywebroom.State.set('tabContentHidden', col)
                        Mywebroom.Helpers.EditorHelper.appendCollection(col, 'HIDDEN')


                    Mywebroom.Data.Editor.offset += limit


              ###
              FIX for Safari 6 on iMac
              Issue: pagination causes editor to scroll to top
              ###
              setTimeout ( ->
                location = Mywebroom.Data.Editor.location

                if location
                  $('.tab-content').scrollTop(location)

              ), 0












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







  filterKeyword: (keyword) ->


    if keyword is null or typeof keyword is "undefined"                   # null / undefined
      ""

    else if typeof keyword is "boolean"
      ""

    else if typeof keyword is "number"                                    # Number

      result = String(keyword)

      if result is "NaN"                                                  # NaN
        ""
      else

        if keyword % 1 is 0                                               # Integers
          result
        else
          result.replace(/\./g, " ").trim()                      # Decimals


    else if not /^[a-z0-9]+$/i.test(keyword)                              # Special character
      keyword.replace(/[^a-z0-9]/ig, " ").trim()
    else                                                                  # Alpha-Numeric
      keyword.trim()




  paginateSearch: (type, limit, offset, keyword) ->

    # Strip special chars, etc. from keyword
    keyword = @filterKeyword(keyword)



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
    limit = Mywebroom.Data.Editor.limit
    designs = Mywebroom.Helpers.EditorHelper.paginateInitial(itemId, limit, 0)




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
    Mywebroom.Helpers.EditorHelper.expandFilters()


    # Collapse location filter
    $('#dropdown-location').addClass('collapse')


    # Populate the filters
    categories = new Mywebroom.Collections.IndexItemsDesignsCategoriesByItemIdCollection()
    categories.fetch
      async: false
      url:   categories.url itemId
      success: (response) ->
        #console.log("designs fetch success", response)
        myModel = categories.first()
        Mywebroom.Helpers.EditorHelper.setCategories(myModel.get('items_designs_categories'))
        Mywebroom.Helpers.EditorHelper.setBrands(myModel.get('items_designs_brands'))
        Mywebroom.Helpers.EditorHelper.setStyles(myModel.get('items_designs_styles'))
        Mywebroom.Helpers.EditorHelper.setColors(myModel.get('items_designs_colors'))
        Mywebroom.Helpers.EditorHelper.setMakes(myModel.get('items_designs_makes'))
    ###
    FILTERS - END
    ###



















  setCategories: (categories) ->

    # empty out existing dropdown items
    $('#dropdown-category > .dropdown-menu').empty()


    # iterate through the category items and create a li out of each one
    _.each(categories, (category) ->
      if category.category
        $('#dropdown-category > .dropdown-menu').append('<li class=\"store-filter-item\"><a href=\"#\">' + _.str.capitalize(category.category) + '</a></li>')
    )




  setBrands: (brands) ->

    # empty out existing dropdown items
    $('#dropdown-brand > .dropdown-menu').empty()


    # iterate through the brand items and create a li out of each one
    _.each(brands, (brand) ->
      if brand.brand
        $('#dropdown-brand > .dropdown-menu').append('<li class=\"store-filter-item\"><a href=\"#\">' + _.str.capitalize(brand.brand) + '</a></li>')
    )




  setLocations: (locations) ->

    # empty out existing dropdown items
    $('#dropdown-location > .dropdown-menu').empty()


    # iterate through the location items and create a li out of each one
    _.each(locations, (location) ->
      if location.location
        $('#dropdown-location > .dropdown-menu').append('<li class=\"store-filter-item\"><a href=\"#\">' + _.str.capitalize(location.location) + '</a></li>')
    )



  setStyles: (styles) ->
    # empty out existing dropdown items
    $('#dropdown-style > .dropdown-menu').empty()


    # iterate through the style items and create a li out of each one
    _.each(styles, (style) ->
      if style.style
        $('#dropdown-style > .dropdown-menu').append('<li class=\"store-filter-item\"><a href=\"#\">' + _.str.capitalize(style.style) + '</a></li>')
    )




  setColors: (colors) ->

    # empty out existing dropdown items
    $('#dropdown-color > .dropdown-menu').empty()


    # iterate through the color items and create a li out of each one
    _.each(colors, (color) ->
      if color.color
        $('#dropdown-color > .dropdown-menu').append('<li class=\"store-filter-item\"><a href=\"#\">' + _.str.capitalize(color.color) + '</a></li>')
    )



  setMakes: (makes) ->

    # empty out existing dropdown items
    $('#dropdown-make > .dropdown-menu').empty()


    # iterate through the make items and create a li out of each one
    _.each(makes, (make) ->
      if make.make
        $('#dropdown-make > .dropdown-menu').append('<li class=\"store-filter-item\"><a href=\"#\">' + _.str.capitalize(make.make) + '</a></li>')
    )




  collapseFilters: ->

    # Add the collapse class
    $('#dropdown-category').addClass('collapse')
    $('#dropdown-style').addClass('collapse')
    $('#dropdown-brand').addClass('collapse')
    $('#dropdown-location').addClass('collapse')
    $('#dropdown-color').addClass('collapse')
    $('#dropdown-make').addClass('collapse')




  expandFilters: ->

    # Remove the collapse class
    $('#dropdown-category').removeClass('collapse')
    $('#dropdown-style').removeClass('collapse')
    $('#dropdown-brand').removeClass('collapse')
    $('#dropdown-location').removeClass('collapse')
    $('#dropdown-color').removeClass('collapse')
    $('#dropdown-make').removeClass('collapse')












  ###
  (1) Store visibility
  (1.1) Scroller visibility
  (2.1) Get saveBarWasVisible
  (2.2) Set saveBarWasVisible
  (2.3) Save, Cancel, Remove view visibility
  (3) Button visibility <-- don't worry about
  (4) Active Nav Tab
  (5) Search filter
  (6) Dropdown filters
  (7) Hidden item visibility: gray or hidden
  (8) Highlighted Images
  (9) Room size & Button class
  (10) Room Item Hover: on or off
  (10.1) Room Item Click: on or off
  (11) Room Mousewheel
  (12) Set Store State
  ###




  ###
  hidden_to_shown
  ###
  showStore: ->
    #console.log("show store")

    # (1) Store visibility
    $('#xroom_storepage').show()


    # (1.1) Scroller visibility
    $("#xroom_scroll_left").hide()
    $("#xroom_scroll_right").hide()


    # (2.1) Get saveBarWasVisible
    # (2.2) Set saveBarWasVisible


    # (2.3) Save, Cancel, Remove view visibility
    $('#xroom_store_menu_save_cancel_remove').hide()


    # (3) Button Visibility
    # n/a


    # (4) Active Nav Tab
    $('a[href="#tab_items"]').tab('show')


    # (5) Search filter
    $('#store-search-dropdown li').removeClass('active') # Remove active class
    $("#store-search-all").addClass("active") # Add active class to ALL
    $('#store-dropdown-btn').text("ALL") # Change the text of the search filter to ALL


    # (6) Dropdown filters
    Mywebroom.Helpers.EditorHelper.collapseFilters()


    # (7) Hidden item visibility: gray or hidden
    Mywebroom.Helpers.grayHidden()


    # (8) Highlighted Images
    # n/a


    # (9) Room size & Button class
    Mywebroom.Helpers.unShrinkStore()


    # (10) Image Hover: on or off
    Mywebroom.Helpers.turnOffHover()


    # (10.1) Image Click: on or off
    Mywebroom.Helpers.turnOffDesignClick()


    # (11) Mousewheel
    # n/a


    # (12) Set Store State
    Mywebroom.State.set("storeState", "shown")





  ###
  init_TO_hidden, shown_TO_hidden, collapsed_TO_hidden
  ###
  hideStore: ->
    #console.log("hide store")

    # (1) Store visibility
    $('#xroom_storepage').hide()


    # (1.1) Scroller visibility
    $("#xroom_scroll_left").show()
    $("#xroom_scroll_right").show()


    # (2.1) Get saveBarWasVisible
    # (2.2) Set saveBarWasVisible


    # (2.3) Save, Cancel, Remove view visibility
    $('#xroom_store_menu_save_cancel_remove').hide()


    # (3) Button Visibility
    # n/a


    # (4) Active Nav Tab
    # n/a


    # (5) Search filter
    # n/a


    # (6) Dropdown filters
    # n/a


    # (7) Hidden item visibility: gray or hidden
    Mywebroom.Helpers.hideHidden()


    # (8) Highlighted Images
    Mywebroom.Helpers.unHighlight()


    # (9) Room size & Button class
    Mywebroom.Helpers.unShrinkStore()


    # (10) Image Hover: on or off
    if Object.keys(Mywebroom.Data.ItemModels).length then Mywebroom.Helpers.turnOnHover()


    # (10.1) Image Click: on or off
    Mywebroom.Helpers.turnOnDesignClick()


    # (11) Mousewheel
    # n/a


    # (12) Set Store State
    Mywebroom.State.set("storeState", "hidden")




  ###
  shown_TO_collapsed
  ###
  collapseStore: ->
    #console.log("collapse store")

    # (1) Store visibility
    $('#xroom_storepage').show()


    # (1.1) Scroller visibility
    $("#xroom_scroll_left").show()
    $("#xroom_scroll_right").show()


    # (2.1) Get saveBarWasVisible
    # (2.2) Set saveBarWasVisible
    Mywebroom.Helpers.setSaveBarVisibility()


    # (2.3) Save, Cancel, Remove view visibility
    $('#xroom_store_menu_save_cancel_remove').hide()


    # (3) Button Visibility
    # n/a


    # (4) Active Nav Tab
    # n/a


    # (5) Search filter
    # n/a


    # (6) Dropdown filters
    # n/a


    # (7) Hidden item visibility: gray or hidden
    # n/a


    # (8) Highlighted Images
    # n/a


    # (9) Room size & Button class
    Mywebroom.Helpers.shrinkStore()


    # (10) Image Hover: on or off
    # n/a


    # (10.1) Image Click: on or off
    # n/a


    # (11) Mousewheel
    # n/a


    # (12) Set Store State
    Mywebroom.State.set("storeState", "collapsed")




  ###
  collapsed_TO_shown
  ###
  expandStore: ->
    #console.log("expand store")

    # (1) Store visibility
    $('#xroom_storepage').show()


    # (1.1) Scroller visibility
    $("#xroom_scroll_left").hide()
    $("#xroom_scroll_right").hide()


    # (2.1) Get saveBarWasVisible
    flag = Mywebroom.State.get("saveBarWasVisible")


    # (2.2) Set saveBarWasVisible


    # (2.3) Save, Cancel, Remove view visibility
    if flag is true
      $('#xroom_store_menu_save_cancel_remove').show()


    # (3) Button Visibility
    # n/a


    # (4) Active Nav Tab
    # n/a


    # (5) Search filter
    # n/a


    # (6) Dropdown filters
    # n/a


    # (7) Hidden item visibility: gray or hidden
    # n/a


    # (8) Highlighted Images
    # n/a


    # (9) Room size & Button class
    Mywebroom.Helpers.unShrinkStore()


    # (10) Image Hover: on or off
    # n/a


    # (10.1) Image Click: on or off
    # n/a


    # (11) Mousewheel
    # n/a


    # (12) Set Store State
    Mywebroom.State.set("storeState", "shown")





}
