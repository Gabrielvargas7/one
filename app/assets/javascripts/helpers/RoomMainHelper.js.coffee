Mywebroom.Helpers.RoomMainHelper = {
  
  grayHidden: ->

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




  hideHidden: ->

    #console.log("HIDE HIDDEN")

    # Show the hidden designs
    $("[data-room-hide=yes]").hide()



  
  highLight: (id) ->

    Mywebroom.Helpers.RoomMainHelper.unHighlight()

    $('[data-design-item-id=' + id + ']').each( ->
      $(this)
      .attr("src", $(this).attr("data-hover-src-client"))
      .attr("data-room-highlighted", true)
      .show()
    )



  
  unHighlight: ->

    #console.log("UNHIGHLIGHT")

    # Revert the highlighting
    $('[data-room-highlighted=true]').each( ->
      $(this)
      .attr("src", $(this).attr("data-main-src-client"))
      .attr("data-room-highlighted", false)
    )




  turnOnHover: ->

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




  turnOffHover: ->

    #console.log("TURN OFF HOVER")

    $('.room_design').each( ->
      $(this).off("mouseenter mouseleave")
    )




  hideScrollers: ->

    #console.log("HIDE SCROLLERS")

    $("#xroom_scroll_left").hide()
    $("#xroom_scroll_right").hide()




  showScrollers: ->

    #console.log("SHOW SCROLLERS")

    $("#xroom_scroll_left").show()
    $("#xroom_scroll_right").show()
    
    
    
    
    
  turnOnDesignClick: ->

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
              Mywebroom.Helpers.RoomMainHelper.centerItem(dom_item_id)

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
                  return Mywebroom.Helpers.BookmarksHelper.createBookmarksView(model)

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
                Mywebroom.Helpers.BookmarksHelper.createBookmarksView(model, dom_item_id)

      ) #end .click for img.room_design
    ) #end $('img.room_design').each







  turnOffDesignClick: ->

    $('img.room_design').off('click')





  centerItem: (item_id) ->


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









  updateRoomDesign: (model) ->

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












  updateRoomTheme: (model) ->

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








  cancelChanges: ->

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










}
