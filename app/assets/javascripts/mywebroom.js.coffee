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
      firstTimePopupItem : 0 #set the item for the first time pupop
      dom_item_id   : false # dom item when is click

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
      tutorialBookmarkView         : false  # A reference to this view


      friendItemPopupView          : false  # A reference to the popup view
      profileHomeView              : false  # A reference to this view
      bookmarksView                : false  # A reference to the bookmarks view that currently open. There should only ever be one.


      roomViewState                     : false # open or closed
      roomHeaderViewState               : false # open or closed
      storeLayoutViewState              : false # open or closed




      tabContentItems         : false
      tabContentThemes        : false
      tabContentBundles       : false
      tabContentEntireRooms   : false
      tabContentHidden        : false






      storeState: false # hidden, collapsed, or shown

      saveBarWasVisible: false # Lets us know if the save bar was showing when we collapsed the store

      storeHelper: false # Store information about the tab or object we're on

      activeSitesMenuView: false #A reference to the Active Sites Menu View.
      searchViewArray: false #A reference to an Array of view on the search
      room0:
        position: -2200
        screen_position: 0
        id: "#xroom_items_0"
      room1:
        position: 0
        screen_position: 1
        id: "#xroom_items_1"
      room2:
        position: 2200
        screen_position: 2
        id: "#xroom_items_2"
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
    Mywebroom.Helpers.EditorHelper.appendCollection(data, 'ITEMS')

  )




  Mywebroom.State.on('change:tabContentThemes', ->

    #console.log('change:tabContentThemes')

    data = Mywebroom.State.get('tabContentThemes')
    Mywebroom.Helpers.EditorHelper.appendCollection(data, 'THEMES')

  )




  Mywebroom.State.on('change:tabContentBundles', ->

    #console.log('change:tabContentBundles')

    data = Mywebroom.State.get('tabContentBundles')
    Mywebroom.Helpers.EditorHelper.appendCollection(data, 'BUNDLES')

  )




  Mywebroom.State.on('change:tabContentEntireRooms', ->

    #console.log('change:tabContentEntireRooms')

    data = Mywebroom.State.get('tabContentEntireRooms')
    Mywebroom.Helpers.EditorHelper.appendCollection(data, 'ENTIRE ROOMS')

  )




  Mywebroom.State.on('change:tabContentHidden', ->

    #console.log('change:tabContentHidden')

    data = Mywebroom.State.get('tabContentHidden')
    Mywebroom.Helpers.EditorHelper.appendCollection(data, 'HIDDEN')

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
      limit: 20
      location: false
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

























  Mywebroom.Helpers.getParameterByName = (name) ->

    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")

    regex = new RegExp("[\\?&]" + name + "=([^&#]*)")

    results = regex.exec(location.search)
    (if not results? then "" else decodeURIComponent(results[1].replace(/\+/g, " ")))




















  Mywebroom.Helpers.grayHidden = ->

    #console.log("GRAY HIDDEN")

    # Show the hidden designs
    $("[data-room-hide=yes]").show()


    # And now we need to replace src with above
    $('[data-room-hide=yes]').each ->


      # Look up the gray object on the corresponding item
      gray = Mywebroom.Data.ItemModels[Number($(this).data().designItemId)].get("image_name_gray")


      # Check to see if the gray link has been added
      if typeof gray isnt "object"
        url = "/assets/fallback/item/default_item.png"
      else
        url = gray.url



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

      #A4(i) Detect if Popup view is in viewport and adjust
        twitterPopupView.detectViewportAndCenter()



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

      #A4(i) Detect if Popup view is in viewport and adjust
        pinboardPopupView.detectViewportAndCenter()

      when 21 #Portrait
        # Open Profile, not Bookmarks.
        Mywebroom.State.get('roomHeaderView').displayProfile()

      else #All other Items- create Bookmarks View
        view = new Mywebroom.Views.BookmarksView(
          {
            items_name:       itemModel.get("name_singular")
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


      $(this).click( (event) ->


        if ((Mywebroom.State.get("roomState") == "SELF") and Mywebroom.State.get("signInState") and Mywebroom.State.get("tutorialStep") != 0)




          # Tutorial -> open the editor store on the item that was click
          dom_item_id = $(this).data().designItemId



          #console.log("Tutorial -> click item: "+dom_item_id)
          #console.log("room step "+Mywebroom.State.get("signInData").get("user_profile").tutorial_step.toString())
          #console.log("Open the editor here on the item that where click-it")



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



              #console.log("David code should be here -> Open the editor here on the item that where click-it")
              Mywebroom.Helpers.EditorHelper.showStore()
              Mywebroom.Helpers.EditorHelper.clickItem(dom_item_id)



              tutorialItemClick = Mywebroom.State.get("tutorialItemClick")
              tutorialItemClick.tutorialClickItemDestroy()
              Mywebroom.State.set("tutorialItemClick",false)

              view = new Mywebroom.Views.TutorialOpenStoreView()
              $("#xroom_tutorial_container").append(view.el)
              view.render()
            else
              #console.log("No valid item -> click item: "+dom_item_id)


        else
          #console.log("No on the Tutorial -> click item")
          # item_id extracted from the clicked element
          dom_item_id = $(this).data().designItemId
          Mywebroom.State.set("dom_item_id",dom_item_id)

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

             #Special Items Checks
              switch(model.get('id'))

                when 21
                  #CASE: You are in a friend's room and click portrait. We want normal behavior here, so we'll create the bookmarks view in this case.
                  #Show Profile and return.
                  return Mywebroom.Helpers.createBookmarksView(model)

              #A. Create PopupFriendItemView

              #A1. if a popup is already made, make sure we close it before creating the new one.
              if Mywebroom.State.get('friendItemPopupView')
                Mywebroom.State.get('friendItemPopupView').closeView()

              #A2. set Data we need for the view
              urlToPopup = Mywebroom.Data.FriendItemPopupUrls[ model.get('id') ]
              model.set('urlToPopup', urlToPopup)


              #A3. create Popup view
              if urlToPopup

                view = new Mywebroom.Views.PopupFriendItemView(itemData: model, coordinates:coordinates)

                #A4. Render Popup view
                $('#room_bookmark_item_id_container_' + dom_item_id).append(view.el)
                view.render()

                #A4(i) Detect if Popup view is in viewport and adjust
                view.detectViewportAndCenter()

                #A5. update State view tracker
                Mywebroom.State.set('friendItemPopupView', view)

            else #roomState is "SELF"
            #(2.2) Create the Bookmarks View.

              #A. get the corresponding model to check for first click
              firstTimeClickedItem = Mywebroom.State.get('roomItems').findWhere({'item_id':model.get('id').toString()})

              #B. Check for first click
              if firstTimeClickedItem.get('first_time_click') is "y" and model.get('id')!=21
                #1. Merge model and firstTimeClickedItem since we need both where we're going.

                #console.log("first time item "+model.get('id'))
                Mywebroom.State.set("firstTimePopupItem",firstTimeClickedItem)

                view = new Mywebroom.Views.RoomFirstTimePopupView()
                $("#xroom_popup_container").append(view.el)
                view.render()


              else
                #(2.2) Create the Bookmarks View. (Function checks for special items like Portrait)
                model.set('coordinates',coordinates)
                Mywebroom.Helpers.createBookmarksView(model, dom_item_id)

      ) #end .click for img.room_design
    ) #end $('img.room_design').each







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
    if not old_design_id or not new_design_id or not old_main_src or not new_main_src or old_design_id.toString() isnt new_design_id.toString() or old_main_src.toString() isnt new_main_src.toString() or old_hover_src.toString() isnt new_hover_src.toString()

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

    $('#xroom_main_container').on "mousewheel",
      (event) ->
        if event.deltaX
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
        console.error("model fetch fail", response.responseText)


    return model








  Mywebroom.Helpers.setItemRefs = ->


    # items
    items = new Mywebroom.Collections.IndexItemsCollection()
    items.fetch
      async: false
      success: (collection, response, options) ->
        #console.log("initial items fetch success", collection)
      error: (collection, response, options) ->
        console.error("initial items fetch fail", response.responseText)


    Mywebroom.State.set("initialItems", items)



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





  Mywebroom.Data.FriendItemPopupUrls = {
      1:   "" #sofa
      2:   "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383348300/birdcage-Friend-Pop-Up-Object_gxaui5.png" #birdcage
      3:   "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383348427/bookstand-Friend-Pop-Up-Object_up9cyp.png" #bookcase
      4:   "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383348575/chair-Friend-Pop-Up-Object_wagoi1.png" #chair
      5:   "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383348940/newspaper-Friend-Pop-Up-Object_nhybid.png" #newspaper
      6:   "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383348860/map-Friend-Pop-Up-Object_gp3jlo.png" #world map
      7:   "" #tv stand
      8:   "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383348727/dresser-Friend-Pop-Up-Object_mwf3fb.png" #dresser
      9:   "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383594435/shoppingbag-Friend-Pop-Up-Object.png" #shopping bag
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
      23:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383349438/window-Friend-Pop-Up-Object_gbupwg.png" #window
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
  }












  ###
  get Item Name of room object from the item's id.
  ###
  Mywebroom.Helpers.getItemNameOfItemId = (modelId) ->

    # Compare modelToBrowse ID to state room designs items id
    for item in Mywebroom.State.get('roomDesigns')
      if modelId is item.item_id
        return item.items_name_singular










  ###
  Checks if signed in user has requested a key from idRequested. returns true/false.
  ###
  Mywebroom.Helpers.IsThisMyFriendRequest = (userIdRequested) ->

    return false if !Mywebroom.State.get("signInUser")

    userId = Mywebroom.State.get("signInUser").get("id")

    hasRequested = new Mywebroom.Collections.ShowFriendRequestByUserIdAndUserIdRequestedCollection([], {userId: userId, userIdRequested: userIdRequested})
    hasRequested.fetch({
      async: false
      success: (collection, response, options) ->
        #console.log("Mywebroom.Helpers.IsThisMyFriendRequest fetch success", collection)

      error: (collection, response, options) ->
        console.error("Mywebroom.Helpers.IsThisMyFriendRequest fetch fail", response.responseText)
    })


    if hasRequested.models.length > 0
      true
    else
      false





  ###
  Request key from signed in user to idRequested
  ###
  Mywebroom.Helpers.RequestKey = (idRequested) ->
    if Mywebroom.State.get('signInUser') and Mywebroom.State.get('signInUser').get('id')
      #Make Key Request
      requestModel = new Mywebroom.Models.CreateFriendRequestByUserIdAndUserIdRequestedModel()
      requestModel.set 'userId', Mywebroom.State.get("signInUser").get("id")
      requestModel.set 'userIdRequested', idRequested
      requestModel.save {},

      success: (model, response) ->
        #console.log('post requestKey SUCCESS:')
        #console.log(response)

      error: (model, response) ->
        console.error('post requestKey FAIL:')
        console.error(response)

      #Change style to Key requested.
      if $('#profile_ask_for_key_overlay button').length is 1
        $requestButton = $('#profile_ask_for_key_overlay button')
        $requestButton.text("Key Requested")
        $requestButton.addClass("profile_key_requested").removeClass('profile_request_key_button')

      #Otherwise, change the style in your code :)

    else
      #send to landing page
      window.location.assign(window.location.protocol + "//" + window.location.host)






  Mywebroom.Helpers.fetchInitialData = ->

    # (1) set staticContent images
    $.ajax
      url: '/static_contents/json/index_static_contents.json'
      type: 'get'
      dataType: 'json'
      async: false
      success: (data) ->
        staticContentCollection = new Backbone.Collection()
        staticContentCollection.add(data)
        Mywebroom.State.set('staticContent', staticContentCollection)


    Mywebroom.Helpers.setItemRefs()








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



  Mywebroom.App.addInitializer ->

    Mywebroom.Helpers.fetchInitialData()

    view = new Mywebroom.Views.RoomView()

    # Save a reference in the state model
    Mywebroom.State.set("roomView", view)




  Mywebroom.App.start()
