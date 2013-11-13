window.Mywebroom = {
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  Helpers:{}
  State:{}
  Data:{}
  App:{}
}


$(document).ready ->

  # Define the state model
  defaultStateModel = Backbone.Model.extend(
    defaults:
      staticContent : false  #Collection of static content images

      roomState     : false  # Who's room are we viewing? PUBLIC, FRIEND, or SELF
      roomUser      : false  # Backbone Model of room user, or false
      roomData      : false  # Backbone Model of room data, or false
      signInState   : false  # Boolean: Is the user signed in?
      signInUser    : false  # Backbone Model of signed-in user, or false
      signInData    : false  # Backbone Model of signed-in user's data, or false

      roomDesigns   : false  # Array of item designs, or empty array
      roomTheme     : false  # Object containing info on room's theme

      initialItems: false # Backbone collection of room items

      $activeDesign           : false  # A refernce to the element of the design in focus*
      activeDesignIsHidden    : false  # yes or no
      tutorialItem            : 13     # is the number of the item the where click on the turotial default is 13
      tutorialBookmarkCounter : 0      #  counter number of bookmark on tutorial
      tutorialStep            : 0      #  step of the tutorial default is 0



      roomView                     : false  # A reference to this view
      roomHeaderView               : false  # A reference to this view
      storeLayoutView              : false  # A reference to this view
      storeMenuSaveCancelRemoveView: false  # A reference to this view
      roomScrollerLeftView         : false  # A reference to this view
      roomScrollerRightView        : false  # A reference to this view
      tutorialItemClick            : false  # A reference to this view
      tutorialBookmarkDiscover     : false  # A reference to this view

      friendItemPopupView          : false  # A reference to the popup view
      profileHomeView              : false  # A reference to this view


      roomViewState                     : false # open or closed
      roomHeaderViewState               : false # open or closed
      storeLayoutViewState              : false # open or closed




      tabContentItems         : false
      tabContentThemes        : false
      tabContentBundles       : false
      tabContentEntireRooms   : false
      tabContentHidden        : false






      storeState : false # hidden, collapsed, or shown

      saveBarWasVisible                 : false # Lets us know if the save bar was showing when we collapsed the store

      storeHelper: false # Store information about the tab or object we're on

      activeSitesMenuView: false #A reference to the Active Sites Menu View.
      searchViewArray:false #A reference to an Array of view on the search
      room0:
        position:-2200
        screen_position:0
        id:"#xroom_items_0"
      room1:
        position:0
        screen_position:1
        id:"#xroom_items_1"
      room2:
        position:2200
        screen_position:2
        id:"#xroom_items_2"




      #An object containing base URLs for the shop.
      shopBaseUrl:
        itemDesign:'http://staging-mywebroom.herokuapp.com/shop/show/items-design/'
        bookmark:'http://mywebroom.com/'
        theme: 'http://mywebroom.com/'
        bundle: 'http://mywebroom.com/'
        entireRoom:'http://mywebroom.com/'
        default: 'http://mywebroom.com/'

    )

  # Create the state model
  Mywebroom.State = new defaultStateModel()

  ###
  *At the present, this gets set when either the object this design
   belongs to is clicked from the store, or a new design was
   chosen from the store. Would probably be good to have this
   get set when a room design is click directly.
  ###



  Mywebroom.State.on('change:tabContentItems', ->

    #console.log('change:tabContentItems')

    data = Mywebroom.State.get('tabContentItems')
    Mywebroom.Helpers.Editor.appendCollection(data, 'ITEMS')

  )




  Mywebroom.State.on('change:tabContentThemes', ->

    #console.log('change:tabContentThemes')

    data = Mywebroom.State.get('tabContentThemes')
    Mywebroom.Helpers.Editor.appendCollection(data, 'THEMES')

  )




  Mywebroom.State.on('change:tabContentBundles', ->

    #console.log('change:tabContentBundles')

    data = Mywebroom.State.get('tabContentBundles')
    Mywebroom.Helpers.Editor.appendCollection(data, 'BUNDLES')

  )




  Mywebroom.State.on('change:tabContentEntireRooms', ->

    #console.log('change:tabContentEntireRooms')

    data = Mywebroom.State.get('tabContentEntireRooms')
    Mywebroom.Helpers.Editor.appendCollection(data, 'ENTIRE ROOMS')

  )




  Mywebroom.State.on('change:tabContentHidden', ->

    #console.log('change:tabContentHidden')

    data = Mywebroom.State.get('tabContentHidden')
    Mywebroom.Helpers.Editor.appendCollection(data, 'HIDDEN')

  )



  ###
  STATIC DATA
  ###
  Mywebroom.Data = {
    ItemModels: {} # format -> 2: Backbone.Model
    ItemNames:  {} # format -> 3: "string"
    ItemIds:    Object.create(null) # *see below # format -> 7: true
    Editor: {
      paginate: false
      contentPath: false # INITIAL, SEARCH
      contentType: false
      keyword: false
      offset: 0
      limit: 10
    }
    searchNum: -1
    FriendItemPopupUrls: {} #format -> 1:"string"
  }


  ###
  *To create a true set [http://en.wikipedia.org/wiki/Set_(mathematics)],
  we want an object that doesn't already have any properties on it.

  http://stackoverflow.com/questions/7958292/mimicking-sets-in-javascript
  http://www.devthought.com/2012/01/18/an-object-is-not-a-hash/

  Since this program speaks coffee, we use "of" to query instead of "in".

  http://stackoverflow.com/questions/6408726/iterate-over-associative-array-in-coffeescript/6408784#6408784
  ###











  Mywebroom.Helpers.onEditorScroll = ->

    ###
    Here, we setup a scroll handler for the editor.
    We trigger actions when the page is scrolled to the bottom.
    ###

    $('.tab-content').scroll( ->

      ###
      ARE WE AT THE BOTTOM?
      ###
      if $(this).scrollTop() + $(this).innerHeight() >= $(this)[0].scrollHeight - 100


        ###
        IS PAGINATE TRUE?
        ###
        if Mywebroom.Data.Editor.paginate is true


          path =    Mywebroom.Data.Editor.contentPath
          type =    Mywebroom.Data.Editor.contentType
          keyword = Mywebroom.Data.Editor.keyword
          limit =   Mywebroom.Data.Editor.limit
          offset  = Mywebroom.Data.Editor.offset + limit


          if path is false then console.error("no pagination type!")




          switch path

            when "INITIAL"

              #console.log("PAGINATE INITIAL - " + type + "\tOffset: " + offset)

              data = Mywebroom.Helpers.Editor.paginateInitial(type, limit, offset)
              #console.log(data.length)

              unless data.length is 0

                switch type

                  when "THEMES"

                    col = Mywebroom.State.get('tabContentThemes')
                    #console.log('initial length', col.length)

                    col.add(data.toJSON(), {silent: false})
                    #console.log('length after add', col.length)

                    Mywebroom.State.set('tabContentThemes', col)
                    Mywebroom.Helpers.Editor.appendCollection(col, 'THEMES')

                  when "BUNDLES"

                    col = Mywebroom.State.get('tabContentBundles')
                    #console.log('initial length', col.length)

                    col.add(data.toJSON(), {silent: false})
                    #console.log('length after add', col.length)


                    Mywebroom.State.set('tabContentBundles', col)
                    Mywebroom.Helpers.Editor.appendCollection(col, 'BUNLDES')

                  when "ENTIRE ROOMS"

                    col = Mywebroom.State.get('tabContentEntireRooms')
                    #console.log('initial length', col.length)

                    col.add(data.toJSON(), {silent: false})
                    #console.log('length after add', col.length)


                    Mywebroom.State.set('tabContentEntireRooms', col)
                    Mywebroom.Helpers.Editor.appendCollection(col, 'ENTIRE ROOMS')

                  else

                    col = Mywebroom.State.get('tabContentHidden')
                    #console.log('initial length', col.length)

                    col.add(data.toJSON(), {silent: false})
                    #console.log('length after add', col.length)


                    Mywebroom.State.set('tabContentHidden', col)
                    Mywebroom.Helpers.Editor.appendCollection(col, 'HIDDEN')


                Mywebroom.Data.Editor.offset += limit


            when "SEARCH"

              #console.log("PAGINATE SEARCH - " + type + "\tOffset: " + offset + "\tKeyword: " + keyword)

              data = Mywebroom.Helpers.Editor.paginateSearch(type, limit, offset, keyword)
              #console.log(data.length)


              unless data.length is 0

                switch type

                  when "THEMES"

                    col = Mywebroom.State.get('tabContentThemes')
                    col.add(data.toJSON(), {silent: false})
                    Mywebroom.State.set('tabContentThemes', col)
                    Mywebroom.Helpers.Editor.appendCollection(col, 'THEMES')

                  when "BUNDLES"

                    col = Mywebroom.State.get('tabContentBundles')
                    col.add(data.toJSON(), {silent: false})
                    Mywebroom.State.set('tabContentBundles', col)
                    Mywebroom.Helpers.Editor.appendCollection(col, 'BUNDLES')

                  when "ENTIRE ROOMS"

                    col = Mywebroom.State.get('tabContentEntireRooms')
                    col.add(data.toJSON(), {silent: false})
                    Mywebroom.State.set('tabContentEntireRooms', col)
                    Mywebroom.Helpers.Editor.appendCollection(col, 'ENTIRE ROOMS')

                  else

                    col = Mywebroom.State.get('tabContentHidden')
                    col.add(data.toJSON(), {silent: false})
                    Mywebroom.State.set('tabContentHidden', col)
                    Mywebroom.Helpers.Editor.appendCollection(col, 'HIDDEN')


                Mywebroom.Data.Editor.offset += limit
    )

















  Mywebroom.Helpers.getParameterByName = (name) ->

    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")

    regex = new RegExp("[\\?&]" + name + "=([^&#]*)")

    results = regex.exec(location.search)

    (if not results? then "" else decodeURIComponent(results[1].replace(/\+/g, " ")))







  Mywebroom.Helpers.showModal = ->
    ###
    MODAL
    ###

    ###
    (1) Get ID of Signed-In User
    (2) Look Up his notifications
          a. Handle Error
    (3) Extract first model
    (4) Check that the model has the notified field
    (5) Only do something if the user hasn't been notified
    (6) Inform server that we've been notified
    ###

    # (1) Get user_id
    user_id = Mywebroom.State.get("signInUser").get("id")


    # (2) Get Notifications
    collection = new Mywebroom.Collections.ShowUserNotificationByUserCollection([], {user_id: user_id})
    collection.fetch
      async: false
      success: (collection, response, options) ->
        #console.log("Notification fetch success", response)

        # (3) Extract first model
        model = collection.first()


        # (4) Check for existance of property we'll need to use
        if model.has("notified")

          # (5) Only show the user a message if he hasn't already been notified
          if model.get("notified") is "n"

            # View
            view = new Mywebroom.Views.InsView({model: model})
            view.render()



            window.lightbox('lightbox-ins', 'shadow-ins')


            $('#lightbox').append(view.el)



            ###
            LET THE SERVER KNOW WE DON'T NEED THIS NOTIFICATION AGAIN - START
            ###

            #console.log("fake tell sever we saw notification")


            note = new Mywebroom.Models.UpdateUserNotificationToNotifiedByUserModel()
            note.save({id: user_id},
              {
                success: (model, response, options) ->
                  console.log("REMOVE NOTIFICATION SUCCESS")
                  #console.log(model, response, options)
                ,
                error: (model, xhr, options) ->
                  console.error("REMOVE NOTIFICATION FAIL")
                  #console.error(model, xhr, options)
              }
            )




            if model.has("position")

              position = model.get("position")

              switch position

                when 1
                  console.log("bookmark notification")
                  $('#lightbox').css("left", "-=500")

                when 2
                  console.log("item notification")
                  $('#lightbox').css("left", "+=500")

                when 3
                  console.log("theme notification")
                  $('#lightbox').css("left", "+=500")

                when 4
                  console.log("other notification - don't move")


            else
              console.error("position field missing", model)

        else
          console.error("notified field missing", model)

      error: (collection, response, options) ->
        console.error("Notification fetch fail", response.responseText)











  Mywebroom.Helpers.setCategories = (categories) ->

    # empty out existing dropdown items
    $('#dropdown-category > .dropdown-menu').empty()


    # iterate through the category items and create a li out of each one
    _.each(categories, (category) ->
      if category.category
        $('#dropdown-category > .dropdown-menu').append('<li class=\"store-filter-item\"><a href=\"#\">' + _.str.capitalize(category.category) + '</a></li>')
    )




  Mywebroom.Helpers.setBrands = (brands) ->

    # empty out existing dropdown items
    $('#dropdown-brand > .dropdown-menu').empty()


    # iterate through the brand items and create a li out of each one
    _.each(brands, (brand) ->
      if brand.brand
        $('#dropdown-brand > .dropdown-menu').append('<li class=\"store-filter-item\"><a href=\"#\">' + _.str.capitalize(brand.brand) + '</a></li>')
    )




  Mywebroom.Helpers.setLocations = (locations) ->

    # empty out existing dropdown items
    $('#dropdown-location > .dropdown-menu').empty()


    # iterate through the location items and create a li out of each one
    _.each(locations, (location) ->
      if location.location
        $('#dropdown-location > .dropdown-menu').append('<li class=\"store-filter-item\"><a href=\"#\">' + _.str.capitalize(location.location) + '</a></li>')
    )

  Mywebroom.Helpers.setStyles = (styles) ->
    # empty out existing dropdown items
    $('#dropdown-style > .dropdown-menu').empty()


    # iterate through the style items and create a li out of each one
    _.each(styles, (style) ->
      if style.style
        $('#dropdown-style > .dropdown-menu').append('<li class=\"store-filter-item\"><a href=\"#\">' + _.str.capitalize(style.style) + '</a></li>')
    )




  Mywebroom.Helpers.setColors = (colors) ->

    # empty out existing dropdown items
    $('#dropdown-color > .dropdown-menu').empty()


    # iterate through the color items and create a li out of each one
    _.each(colors, (color) ->
      if color.color
        $('#dropdown-color > .dropdown-menu').append('<li class=\"store-filter-item\"><a href=\"#\">' + _.str.capitalize(color.color) + '</a></li>')
    )



  Mywebroom.Helpers.setMakes = (makes) ->

    # empty out existing dropdown items
    $('#dropdown-make > .dropdown-menu').empty()


    # iterate through the make items and create a li out of each one
    _.each(makes, (make) ->
      if make.make
        $('#dropdown-make > .dropdown-menu').append('<li class=\"store-filter-item\"><a href=\"#\">' + _.str.capitalize(make.make) + '</a></li>')
    )


  Mywebroom.Helpers.collapseFilters = ->

    # Add the collapse class
    $('#dropdown-category').addClass('collapse')
    $('#dropdown-style').addClass('collapse')
    $('#dropdown-brand').addClass('collapse')
    $('#dropdown-location').addClass('collapse')
    $('#dropdown-color').addClass('collapse')
    $('#dropdown-make').addClass('collapse')

  Mywebroom.Helpers.expandFilters = ->

    # Remove the collapse class
    $('#dropdown-category').removeClass('collapse')
    $('#dropdown-style').removeClass('collapse')
    $('#dropdown-brand').removeClass('collapse')
    $('#dropdown-location').removeClass('collapse')
    $('#dropdown-color').removeClass('collapse')
    $('#dropdown-make').removeClass('collapse')




  Mywebroom.Helpers.greyHidden = ->

    #console.log("GREY HIDDEN")

    # Show the hidden designs
    $("[data-room-hide=yes]").show()


    # And now we need to replace src with above
    $('[data-room-hide=yes]').each ->


      # Look up the grey object on the corresponding item
      grey = Mywebroom.Data.ItemModels[Number($(this).data().designItemId)].get("image_name_grey")


      # Check to see if the grey link has been added
      if typeof grey isnt "object"
        url = "/assets/fallback/item/default_item.png"
      else
        url = grey.url



      $(this).attr("src", url)




  Mywebroom.Helpers.hideHidden = ->

    #console.log("HIDE HIDDEN")

    # Show the hidden designs
    $("[data-room-hide=yes]").hide()



  Mywebroom.Helpers.unHighlight = ->

    #console.log("UNHIGHLIGHT")

    # Revert the highlighting
    $('[data-room-highlighted=true]').each( ->
      $(this)
      .attr("src", $(this).attr("data-main-src-client"))
      .attr("data-room-highlighted", false)
    )



  Mywebroom.Helpers.highLight = (id) ->

    Mywebroom.Helpers.unHighlight()

    $('[data-design-item-id=' + id + ']').each( ->
      $(this)
      .attr("src", $(this).attr("data-hover-src-client"))
      .attr("data-room-highlighted", true)
      .show()
    )



  Mywebroom.Helpers.turnOnHover = ->

    #console.log("TURN ON HOVER")


    $('.room_design').each( ->

      dom_item_id = $(this).data().designItemId


      # model associated with this item_id
      model = Mywebroom.Data.ItemModels[dom_item_id]


      if not model.has('clickable')

        console.error('model without clickable property', model)

      else

        if model.get('clickable') is 'yes'

          $(this)
          .mouseenter( -> $(this).attr("src", $(this).attr("data-hover-src-client")))
          .mouseleave( -> $(this).attr("src", $(this).attr("data-main-src-client")))
    )


  Mywebroom.Helpers.turnOffHover = ->

    #console.log("TURN OFF HOVER")

    $('.room_design').each( ->
      $(this).off("mouseenter mouseleave")
    )



  Mywebroom.Helpers.hideScrollers = ->

    #console.log("HIDE SCROLLERS")

    $("#xroom_scroll_left").hide()
    $("#xroom_scroll_right").hide()


  Mywebroom.Helpers.showScrollers = ->

    #console.log("SHOW SCROLLERS")

    $("#xroom_scroll_left").show()
    $("#xroom_scroll_right").show()


  Mywebroom.Helpers.shrinkStore = ->

    #console.log("SHRINK STORE")

    $('.store_main_box_right').hide() # Hide the main box
    $('#store_main_box').css('width', '40px')
    $('#store_collapse_img').attr('src','http://res.cloudinary.com/hpdnx5ayv/image/upload/v1375811602/close-arrow_nwupj2.png')
    $('#store_collapse_button img').removeClass('flipimg') # Button now faces the left



  Mywebroom.Helpers.unShrinkStore = ->

    #console.log("UNSHRINK STORE")

    $('.store_main_box_right').show() # Un-hide the main box

    # Note: this width should be the same as #store_main_box in stylesheets/rooms_store.css.scss
    $('#store_main_box').css('width', '700px')

    $('#store_collapse_button img').addClass('flipimg')



  Mywebroom.Helpers.setSaveBarVisibility = ->

    #console.log("SET SAVEBAR VISIBILITY")

    visible = $('#xroom_store_menu_save_cancel_remove').is(":visible")
    Mywebroom.State.set("saveBarWasVisible", visible)




  Mywebroom.Helpers.cancelChanges = ->

    #console.log("CANCEL CHANGES")

    # CANCEL DESIGNS
    $("[data-design-has-changed=true]").each( ->
        $(this)
        .attr("src", $(this).attr("data-main-src-server"))
        .attr("data-main-src-client",  $(this).attr("data-main-src-server"))
        .attr("data-hover-src-client", $(this).attr("data-hover-src-server"))
        .attr("data-design-id-client", $(this).attr("data-design-id-server"))
        .attr("data-design-has-changed", false)
    )


    # CANCEL THEMES
    $("[data-theme-has-changed=true]").each( ->
        $(this)
        .attr("src", $(this).attr("data-theme-src-server"))
        .attr("data-theme-src-client", $(this).attr("data-theme-src-server"))
        .attr("data-theme-id-client", $(this).attr("data-theme-id-server"))
        .attr("data-theme-has-changed", false)
    )




  Mywebroom.Helpers.createBookmarksView = (itemModel, DomItemId) ->

    switch (itemModel.get('id'))

      when 2 #BirdCage
      #Open Popup and on close, go to website.
      #1. Get popupUrl
        urlToPopup = Mywebroom.State.get('staticContent').findWhere({"name":"twitter-external-site-popup"})
        urlToPopup = urlToPopup.get('image_name').url if urlToPopup

      #2. Set Data: coordinates, button text, url

        itemModel.set('urlToPopup',urlToPopup)
        itemModel.set('buttonText',"Continue")
        coordinates = itemModel.get('coordinates')

      #3. Create View. View handles external link opening.
        twitterPopupView = new Mywebroom.Views.PopupExternalSiteWarningView(
                                        {
                                          itemData:    itemModel
                                          coordinates: coordinates
                                          externalUrl: "http://www.twitter.com"
                                        })
      #4. Render View
        twitterPopupView.render().el
        $('#room_bookmark_item_id_container_' + DomItemId).append(twitterPopupView.el)



      when 20 #Pinboard
      #Open Popup and on close, go to website.
      #1. Get popupUrl
        urlToPopup = Mywebroom.State.get('staticContent').findWhere({"name":"pinboard-external-site-popup"})
        urlToPopup = urlToPopup.get('image_name').url if urlToPopup

      #2. Set Data: coordinates, button text, url

        itemModel.set('urlToPopup',urlToPopup)
        itemModel.set('buttonText',"Continue")
        coordinates = itemModel.get('coordinates')

      #3. Create View. View handles external link opening.
        pinboardPopupView = new Mywebroom.Views.PopupExternalSiteWarningView(
                                        {
                                          itemData:    itemModel
                                          coordinates: coordinates
                                          externalUrl: "http://www.pinterest.com"
                                        })
      #4. Render View
        pinboardPopupView.render().el
        $('#room_bookmark_item_id_container_' + DomItemId).append(pinboardPopupView.el)


      when 21 #Portrait
        # Open Profile, not Bookmarks.
        Mywebroom.State.get('roomHeaderView').displayProfile()

      else #All other Items- create Bookmarks View
        view = new Mywebroom.Views.BookmarksView(
          {
            items_name:       itemModel.get("name")
            item_id:          itemModel.get("id")
            user:             Mywebroom.State.get("roomUser").get("id")
          }
        )

        $('#room_bookmark_item_id_container_' + DomItemId).append(view.el)
        view.render()




  Mywebroom.Helpers.turnOnDesignClick = ->

    user_id = Mywebroom.State.get("roomUser").get("id")

    $('img.room_design').each( ->

      $(this).off('click') # So we don't have multiple click handlers


      $(this).click( (event)->


        if ((Mywebroom.State.get("roomState") == "SELF") and Mywebroom.State.get("signInState") and Mywebroom.State.get("tutorialStep") != 0)




          # Tutorial -> open the editor store on the item that was click
          dom_item_id = $(this).data().designItemId


          console.log("Tutorial -> click item: "+dom_item_id)
          console.log("room step "+Mywebroom.State.get("signInData").get("user_profile").tutorial_step.toString())
          console.log("Open the editor here on the item that where click-it")



          model = Mywebroom.Data.ItemModels[dom_item_id]

          if model.get("clickable") is "yes"
            # this are specila item 2 = bird cage , 21 = portrait , 20 = pinboard
            if (dom_item_id != 2 and dom_item_id != 20 and dom_item_id != 21)

              ###
                CENTER ITEM
              ###
              Mywebroom.Helpers.centerItem(dom_item_id)

              # Set the item for the tutorial
              Mywebroom.State.set("tutorialItem",dom_item_id)

              user_id  = Mywebroom.State.get("signInUser").get("id")
              tutorial_step = 3
              # save the new step on the tutorial
              Mywebroom.Helpers.TutorialHelper.saveTutorialStep(user_id,tutorial_step)



              console.log("David code should be here -> Open the editor here on the item that where click-it")
              Mywebroom.Helpers.showStore()
              Mywebroom.Helpers.Editor.clickItem(dom_item_id)



              tutorialItemClick = Mywebroom.State.get("tutorialItemClick")
              tutorialItemClick.tutorialClickItemDestroy()
              Mywebroom.State.set("tutorialItemClick",false)

              view = new Mywebroom.Views.TutorialOpenStoreView()
              $("#xroom_tutorial_container").append(view.el)
              view.render()
            else
              console.log("No valid item -> click item: "+dom_item_id)


        else
          console.log("No on the Tutorial -> click item")
          # item_id extracted from the clicked element
          dom_item_id = $(this).data().designItemId



          # model associated with this item_id
          model = Mywebroom.Data.ItemModels[dom_item_id]


          ###
          Close all bookmark containers except this item's
          ###
          for key of Mywebroom.Data.ItemIds
            el = $('#room_bookmark_item_id_container_' + key)
            if dom_item_id.toString() is key.toString() then el.show() else el.hide()


          ###
          Show / Hide various divs
          ###
          $('#xroom_store_menu_save_cancel_remove').hide()
          $('#xroom_storepage').hide()
          $('#xroom_profile').hide()
          $('#xroom_bookmarks').show()

          ###
          Create bookmark view (maybe)
          ###
          #1. Check if model is clickable
          #2. Check if roomState is Friend or self
          #(2.1) - Friends Popups
          #(2.2) - Check if this is the first click.
          #      - a. Create Bookmarks View (which checks for special items like portrait)

          if model.get("clickable") is "yes"

            #2. Check if Friend's Room
            #2A. get coordinates of click for case of POPUPS
            if event
              coordinates =
                left:event.pageX
                top:event.pageY
            else
              coordinates =
                top:model.get('y')
                left:model.get('x')


            if Mywebroom.State.get('roomState') is "FRIEND" #Public is not clickable so no worry here.
             #(2.1)show the popups

              #A. Create PopupFriendItemView

              #A1. if a popup is already made, make sure we close it before creating the new one.
              if Mywebroom.State.get('friendItemPopupView')
                Mywebroom.State.get('friendItemPopupView').closeView()

              #A2. set Data we need for the view
              urlToPopup = Mywebroom.Data.FriendItemPopupUrls[ model.get('id') ]
              model.set('urlToPopup', urlToPopup)


              #A3. create Popup view
              view = new Mywebroom.Views.PopupFriendItemView(itemData: model,coordinates:coordinates)

              #A4. Render Popup view
              $('#room_bookmark_item_id_container_' + dom_item_id).append(view.el)
              view.render()

              #A5. update State view tracker
              Mywebroom.State.set('friendItemPopupView',view)

            else #roomState is "SELF"
            #(2.2) Create the Bookmarks View.

              #A. get the corresponding model to check for first click
              firstTimeClickedItem = Mywebroom.State.get('roomItems').findWhere({'item_id':model.get('id').toString()})

              #B. Check for first click
              if firstTimeClickedItem.get('first_time_click') is "y" and model.get('id')!=21
                #1. Merge model and firstTimeClickedItem since we need both where we're going.
                itemData = new Backbone.Model(firstTimeClickedItem.toJSON())
                itemData.set(model.toJSON())
                itemData.set('urlToPopup',firstTimeClickedItem.get('image_name_first_time_click').url)
                itemData.set('coordinates',coordinates) #Setting these for the case when: firstClick to Special Item Popup View

                #2. Show Popup
                Mywebroom.Helpers.createFirstTimeClickPopupView(itemData,dom_item_id)

              else
                #(2.2) Create the Bookmarks View. (Function checks for special items like Portrait)
                model.set('coordinates',coordinates)
                Mywebroom.Helpers.createBookmarksView(model, dom_item_id)

      ) #end .click for img.room_design
    ) #end $('img.room_design').each

  Mywebroom.Helpers.createFirstTimeClickPopupView = (itemData, dom_item_id) ->

    #1. Define Special view for firstTimeClicks
    #1a. When popup closes, Tell DB user item was clicked
    #1b. When popup closes, show Bookmarks Interface.

    #This view extends PopupFriendItemView. remove() is overriding Backbone's so we can show bookmarks view when popup closes.
    FirstClickView = Mywebroom.Views.PopupFriendItemView.extend({
                      template:JST['rooms/PopUpItemFirstClickTemplate'],
                      className:"popup_item_first_click_view",

                      #Override Backbone.View::remove
                      remove: ->

                        #1a. Send DB clicked item. Also, change the StateModel, so clicking again won't count as first time.
                        updateClickedItemModel = new Mywebroom.Models.UpdateUserItemDesignFirstTimeClickByUserIdAndDesignIdAndLocationId({id:0})
                        updateClickedItemModel.userId = Mywebroom.State.get('roomData').get('user').id
                        updateClickedItemModel.designId = itemData.get('items_design_id')
                        updateClickedItemModel.locationId = itemData.get('location_id')
                        updateClickedItemModel.save #Makes PUT request to DB at #/users_items_designs/json/update_user_items_design_first_time_click_to_not_by_user_id_and_items_design_id_and_location_id/10000001/1000/1.json
                          wait: true

                        #1a.. Update State Model locally so we don't have to refetch
                        Mywebroom.State.get('roomItems').findWhere({'item_id':itemData.get('item_id').toString()}).set('first_time_click',"n")

                        #1b. Show bookmarks view.
                        Mywebroom.Helpers.createBookmarksView(@itemData, @options.dom_item_id) if @itemData and @options.dom_item_id

                        #1c. Call the base class remove method
                        Backbone.View::remove.apply this

                    })

    #2. Create First Time Popup View instance
    firstClickView = new FirstClickView(
                      itemData:itemData
                      dom_item_id:dom_item_id)
    #3. Render the view
    $('body').append(firstClickView.render().el)



  Mywebroom.Helpers.turnOffDesignClick = ->

    $('img.room_design').off('click')




  Mywebroom.Helpers.centerItem = (item_id) ->


    # Look up the item model
    model = Mywebroom.Data.ItemModels[item_id]


    ###
    BASED ON X and Y COORDINATES
    ###
    item_location_x = parseInt(model.get('x'))
    item_location_y = parseInt(model.get('y'))


    #console.log('item location y', item_location_y)

    @room0 = Mywebroom.State.get('room0')
    @room0.position = -2200 - item_location_x + 100
    @room0.screen_position = 0
    $(@room0.id).css({
      'left': @room0.position
    })


    @room1 = Mywebroom.State.get('room1')
    @room1.position = 0 - item_location_x + 100
    @room1.screen_position = 1
    $(@room1.id).css({
      'left': @room1.position
    })


    @room2 = Mywebroom.State.get('room2')
    @room2.position = 2200 - item_location_x + 100
    @room2.screen_position = 2
    $(@room2.id).css({
      'left': @room2.position
    })
    Mywebroom.State.set('room0',@room0)
    Mywebroom.State.set('room1',@room1)
    Mywebroom.State.set('room2',@room2)
    console.log("p0")
    console.log(@room0)
    console.log("p1")
    console.log(@room1)
    console.log("p2")
    console.log(@room2)





    #  $('#xroom_items_0').attr('data-current_screen_position','0')
    #    $('#xroom_items_0').css({
    #      'left': Math.floor(-2200 - item_location_x + 100)
    #    })
    #
    #    #console.log('room top', $('#xroom_items_0').css('top'))
    #    #console.log('room bottom', $('#xroom_items_0').css('bottom'))
    #
    #    $('#xroom_items_1').attr('data-current_screen_position','1')
    #    $('#xroom_items_1').css({
    #      'left': Math.floor(0 - item_location_x + 100)
    #    })
    #
    #    $('#xroom_items_2').attr('data-current_screen_position','2')
    #    $('#xroom_items_2').css({
    #      'left': Math.floor(2200 - item_location_x + 100)
    #    })
    #

    ###
    ScrollTo Y Value - 100
    ###
    $.scrollTo(item_location_y - 100, {axis: 'y'})

  Mywebroom.Helpers.updateRoomDesign = (model) ->

    #console.log("updateRoomDesign")

    ###
    DESIGN TYPE
    ###
    design_type = model.get("item_id")


    ###
    NEW PROPERTIES
    ###
    new_design_id = model.get("id")
    new_main_src =  model.get("image_name").url
    new_hover_src = model.get("image_name_hover").url




    ###
    CURRENT ITEM
    ###
    current_design = $('[data-design-item-id=' + design_type + ']')




    ###
    OLD PROPERTIES
    ###
    old_design_id = current_design.attr("data-design-id-server")
    old_main_src =  current_design.attr("data-main-src-server")
    old_hover_src = current_design.attr("data-hover-src-server")




    ###
    UPDATE DOM PROPERTIES
    ###
    current_design
    .attr("src", new_hover_src)
    .attr("data-design-id-client", new_design_id)
    .attr("data-main-src-client", new_main_src)
    .attr("data-hover-src-client", new_hover_src)
    .attr("data-room-highlighted", true)





    ###
    CHECK IF DESIGN IS NEW
    ###
    if old_design_id.toString() isnt new_design_id.toString() or old_main_src.toString() isnt new_main_src.toString() or old_hover_src.toString() isnt new_hover_src.toString()

      # Design is changed
      current_design.attr("data-design-has-changed", true)

      # Show the save button
      $('#xroom_store_save').show()

      # Show the cancel button
      $('#xroom_store_cancel').show()

      # Show the remove button unless the current design is hidden
      unless current_design.attr("data-room-hide") is "yes"
        $('#xroom_store_remove').show()

    else

      # Design is un-changed
      current_design.attr("data-design-has-changed", false)












  Mywebroom.Helpers.updateRoomTheme = (model) ->

    #console.log("updateRoomTheme")

    ###
    NEW PROPERTIES
    ###
    new_url =      model.get('image_name').url
    new_theme_id = model.get('id')




    ###
    CURRENT THEME
    ###
    current_theme = $('.current_background')




    ###
    OLD PROPERTIES
    ###
    old_url =      current_theme.attr("data-theme-src-server")
    old_theme_id = current_theme.attr("data-theme-id-server")




    ###
    UPDATE DOM PROPERTIES
    ###
    current_theme
    .attr("src", new_url)
    .attr("data-theme-id-client", new_theme_id)
    .attr("data-theme-src-client", new_url)




    ###
    CHECK IF THEME IS NEW
    ###
    if old_url.toString() isnt new_url.toString() or old_theme_id.toString() isnt new_theme_id.toString()

      # Theme has changed
      current_theme.attr("data-theme-has-changed", true)

      # SET STATE OF SAVE, CANCEL, REMOVE BUTTONS
      # Show the save button
      $('#xroom_store_save').show()

      # Show the cancel button
      $('#xroom_store_cancel').show()

      # Hide the remove button
      $('#xroom_store_remove').hide()

    else

      # Theme is un-changed
      current_theme.attr("data-theme-has-changed", false)











  Mywebroom.Helpers.showSaveBar = ->

    if $('[data-design-has-changed=true]').size() > 0 or $('[data-theme-has-changed=true]').size() > 0

      # Show the Save Bar
      $("#xroom_store_menu_save_cancel_remove").show()

    else

      # Hide the Save Bar
      $("#xroom_store_menu_save_cancel_remove").hide()




  Mywebroom.Helpers.turnOffMousewheel = ->
    #console.log("turn off mousewheel")

    $('#xroom_main_container').mousewheel (event, delta, deltaX, deltaY) ->
      if deltaX
        event.preventDefault()
        event.stopPropagation()



  Mywebroom.Helpers.getSEOLink = (id, type) ->

    ###
    TYPES: ENTIRE_ROOM, BUNDLE, THEME, BOOKMARK, DESIGN
    ###


    model = new Mywebroom.Models.ShowSeoLinkByIdModel({id: id, type: type})
    model.fetch
      async: false
      success: (model, response, options) ->
        #console.log("model fetch success", model, response, options)
      error: (model, response, options) ->
        console.log("model fetch fail", model, response, options)


    return model



  Mywebroom.Helpers.setItemRefs = ->

    items = Mywebroom.State.get("initialItems")


    items.each( (item) ->


      # (1) Create a (unique) set of the item id's
      id = item.get("id")
      Mywebroom.Data.ItemIds[id] = true


      # (2) Store a reference to the item models based on id
      Mywebroom.Data.ItemModels[id] = item


      # (3) Assocaiate item names with item ids
      name = item.get("name")
      Mywebroom.Data.ItemNames[id] = name
    )

    Mywebroom.Data.FriendItemPopupUrls =
      1:   ""#sofa
      2:   "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383348300/birdcage-Friend-Pop-Up-Object_gxaui5.png" #birdcage
      3:   "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383348427/bookstand-Friend-Pop-Up-Object_up9cyp.png" #bookcase
      4:   "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383348575/chair-Friend-Pop-Up-Object_wagoi1.png" #chair
      5:   "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383348940/newspaper-Friend-Pop-Up-Object_nhybid.png" #newspaper
      6:   "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383348860/map-Friend-Pop-Up-Object_gp3jlo.png" #world map
      7:   "" #tv stan
      8:   "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383348727/dresser-Friend-Pop-Up-Object_mwf3fb.png" #dresser
      9:   "https://res.cloudinary.com/hpdnx5ayv/image/upload/v1383594435/shoppingbag-Friend-Pop-Up-Object.png" #shopping bag
      10:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383349273/socialcanvas-Friend-Pop-Up-Object_pvzhz4.png" #social canvas
      11:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383349372/wallshelf-Friend-Pop-Up-Object_ylcro0.png" #wall shelf
      12:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383348903/music-Friend-Pop-Up-Object_n4bmwf.png" #music player
      13:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383349332/tv-Friend-Pop-Up-Object_ufnnkq.png" #tv
      14:  "" #desk
      15:  "" #nightstand
      16:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383349004/notebook-Friend-Pop-Up-Object_xmertw.png" #notebook
      17:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383348606/computer-Friend-Pop-Up-Object_n8smns.png" #computer
      18:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383349077/phone-Friend-Pop-Up-Object_a43ejg.png" #phone
      19:  "" #lamp
      20:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383349151/pinboard-Friend-Pop-Up-Object_iztyad.png" #pinboard
      21:  "" #portrait
      22:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383349306/sport-Friend-Pop-Up-Object_yxtfe5.png" #sports
      23:  "http://res.cloudinary.com/hpdnx5ayv/image/upload/v1383349438/window-Friend-Pop-Up-Object_gbupwg.png" #window
      24:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383348514/box-Friend-Pop-Up-Object_eixd0j.png" #box
      25:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383348798/games-Friend-Pop-Up-Object_qphqgk.png" #games
      26:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383348829/hobbies-Friend-Pop-Up-Object_x4ev1a.png" #hobbies
      27:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383349110/photography-Friend-Pop-Up-Object_izyrpc.png" #photography
      28:  "" #table
      29:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383348775/food-Friend-Pop-Up-Object_t3g7ir.png" #food
      30:  "" #stool
      31:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383349192/poster-Friend-Pop-Up-Object_dsplbv.png" #poster
      32:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383349037/pets-Friend-Pop-Up-Object_xtsvfq.png" #pet
      33:  "" #chandelier
      34:  "" #rug
      35:  "" #carpet
      ##DECOR? https://res.cloudinary.com/hpdnx5ayv/image/upload/v1383348640/decor-Friend-Pop-Up-Object_phompc.png







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
  (7) Hidden item visibility: grey or hidden
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
  Mywebroom.Helpers.showStore = ->
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
    Mywebroom.Helpers.collapseFilters()


    # (7) Hidden item visibility: grey or hidden
    Mywebroom.Helpers.greyHidden()


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
  Mywebroom.Helpers.hideStore = ->
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


    # (7) Hidden item visibility: grey or hidden
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
  Mywebroom.Helpers.collapseStore = ->
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


    # (7) Hidden item visibility: grey or hidden
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
  Mywebroom.Helpers.expandStore = ->
    console.log("expand store")

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


    # (7) Hidden item visibility: grey or hidden
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

  ###
  get Item Name of room object from the item's id.
  ###
  Mywebroom.Helpers.getItemNameOfItemId = (modelId) ->

    # Compare modelToBrowse ID to state room designs items id
    for item in Mywebroom.State.get('roomDesigns')
      if modelId is item.item_id
        return item.items_name

  ###
  Checks if signed in user has requested a key from idRequested. returns true/false.
  ###
  Mywebroom.Helpers.IsThisMyFriendRequest = (idRequested) ->
    hasRequested = new Mywebroom.Collections.ShowFriendRequestByUserIdAndUserIdRequestedCollection()
    hasRequested.fetch
      async  : false
      url    : hasRequested.url(Mywebroom.State.get("signInUser").get("id"),idRequested)

    if hasRequested.models.length > 0
      true
    else
      false

  ###
  Request key from signed in user to idRequested
  ###
  Mywebroom.Helpers.RequestKey = (idRequested) ->
    if Mywebroom.State.get('signInUser').get('id')
      #Make Key Request
      requestModel = new Mywebroom.Models.CreateFriendRequestByUserIdAndUserIdRequestedModel()
      requestModel.set 'userId', Mywebroom.State.get("signInUser").get("id")
      requestModel.set 'userIdRequested', idRequested
      requestModel.save {},

      success: (model, response) ->
        console.log('post requestKey SUCCESS:')
        console.log(response)

      error: (model, response) ->
        console.log('post requestKey FAIL:')
        console.log(response)

      #Change style to Key requested.
      if $('#profile_ask_for_key_overlay button').length > 1
        $requestButton = $('#profile_ask_for_key_overlay button')
      else
        $requestButton = $('.profile_request_key_button')
      $requestButton.text("Key Requested")
      $requestButton.addClass("profile_key_requested").removeClass('profile_request_key_button')


    else
      #send to landing page
      window.location.replace(Mywebroom.State.get("shopBaseUrl").default)







  # Create the Marionette App Object
  Mywebroom.App = new Backbone.Marionette.Application()

  # Create Regions
  Mywebroom.App.addRegions
    xroom_main_container               : "#xroom_main_container"
    xroom_scroll_left                  : "#xroom_scroll_left"
    xroom_store_menu_save_cancel_remove: "#xroom_store_menu_save_cancel_remove"
    xroom_profile                      : "#xroom_profile"
    xroom_storepage                    : "#xroom_storepage"
    xroom_bookmarks                    : "#xroom_bookmarks"
    xroom_bookmarks_browse_mode        : "#xroom_bookmarks_browse_mode"
    xroom_footer                       : "#xroom_footer"
    xroom_scroll_right                 : "#xroom_scroll_right"
    xroom                              : "#xroom"
    xroom_items_0                      : "#xroom_items_0"
    xroom_items_1                      : "#xroom_items_1"
    xroom_itmes_2                      : "#xroom_items_2"
    xroom_header                       : "#xroom_header"



  Mywebroom.App.addInitializer ->
    new Mywebroom.Routers.RoomsRouter()
    Backbone.history.start() if Backbone.history




  Mywebroom.App.start()
