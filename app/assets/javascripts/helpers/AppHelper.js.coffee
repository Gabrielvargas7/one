Mywebroom.Helpers.AppHelper = {


  showModal: ->

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
    collection.fetch({
      async: false
      success: (collection, response, options) ->

        if collection and collection.length

          #console.log("Notification fetch success", collection)

          # (3) Extract first model
          model = collection.first()


          # (4) Check for existance of property we'll need to use
          if model.has("notified")

            # (5) Only show the user a message if he hasn't already been notified
            if model.get("notified") is "n"

              # View
              view = new Mywebroom.Views.InsView({model: model})
              view.render()


              Mywebroom.Helpers.LightboxHelper.lightbox('lightbox-ins', 'lightbox-shadow-ins')


              $('#lightbox').append(view.el)



              ###
              LET THE SERVER KNOW WE DON'T NEED THIS NOTIFICATION AGAIN - START
              ###

              #console.log("fake tell sever we saw notification")



              note = new Mywebroom.Models.UpdateUserNotificationToNotifiedByUserModel()
              note.save({id: user_id},
                {
                  success: (model, response, options) ->
                    #console.log("REMOVE NOTIFICATION SUCCESS")
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

                  when 1 then false
                    #console.log("bookmark notification - no position change")

                  when 2
                    #console.log("item notification - move top right")
                    $('#lightbox').css({
                      "left": "79%"
                      "top": "-=140"
                    })

                  when 3
                    #console.log("theme notification - move top right")
                    $('#lightbox').css({
                      "left": "79%"
                      "top": "-=140"
                    })

                  when 4
                    #console.log("new version notification - move top right")
                    $('#lightbox').css({
                      "left": "79%"
                      "top": "-=140"
                    })



              else
                console.error("position field missing", model)

          else
            console.error("notified field missing", model)

        else
          #console.log("Woo hoo! We prevented an error!")

      error: (collection, response, options) ->
        console.error("Notification fetch fail", response.responseText)

    })




  turnOffMousewheel: ->
    #console.log("turn off mousewheel")

    $('#xroom_main_container').on("mousewheel",
      (event) ->
        if event.deltaX
          event.preventDefault()
          event.stopPropagation()
    )




  setItemRefs: ->


    # items
    items = new Mywebroom.Collections.IndexItemsCollection()
    items.fetch({
      async: false
      success: (collection, response, options) ->
        #console.log("initial items fetch success", collection)
      error: (collection, response, options) ->
        console.error("initial items fetch fail", response.responseText)
    })

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




  fetchInitialData: ->

    # (1) set staticContent images
    $.ajax({
      url: '/static_contents/json/index_static_contents.json'
      type: 'get'
      dataType: 'json'
      async: false
      success: (data) ->
        staticContentCollection = new Backbone.Collection()
        staticContentCollection.add(data)
        Mywebroom.State.set('staticContent', staticContentCollection)
    })


    Mywebroom.Helpers.AppHelper.setItemRefs()




  getParameterByName: (name) ->

    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")

    regex = new RegExp("[\\?&]" + name + "=([^&#]*)")

    results = regex.exec(location.search)
    (if not results? then "" else decodeURIComponent(results[1].replace(/\+/g, " ")))




  getSEOLink: (id, type) ->

    ###
    TYPES: ENTIRE_ROOM, BUNDLE, THEME, BOOKMARK, DESIGN
    ###
    model = new Mywebroom.Models.ShowSeoLinkByIdModel({id: id, type: type})
    model.fetch({
      async: false
      success: (model, response, options) ->
        #console.log("model fetch success", model, response, options)
      error: (model, response, options) ->
        console.error("model fetch fail", response.responseText)
    })


    return model




  ###
  get Item Name of room object from the item's id.
  ###
  getItemNameOfItemId: (modelId) ->

    # Compare modelToBrowse ID to state room designs items id
    for item in Mywebroom.State.get('roomDesigns')
      if modelId is item.item_id
        return item.items_name_singular




  ###
  Checks if signed in user has requested a key from idRequested. returns true/false.
  ###
  IsThisMyFriendRequest: (userIdRequested) ->

    return false if !Mywebroom.State.get("signInUser")

    userId = Mywebroom.State.get("signInUser").get("id")

    hasRequested = new Mywebroom.Collections.ShowFriendRequestByUserIdAndUserIdRequestedCollection([], {userId: userId, userIdRequested: userIdRequested})
    hasRequested.fetch({
      async: false
      success: (collection, response, options) ->
        #console.log("Mywebroom.Helpers.AppHelper.IsThisMyFriendRequest fetch success", collection)

      error: (collection, response, options) ->
        console.error("Mywebroom.Helpers.AppHelper.IsThisMyFriendRequest fetch fail", response.responseText)
    })


    if hasRequested.models.length > 0
      true
    else
      false




  ###
  Request key from signed in user to idRequested
  ###
  RequestKey: (idRequested) ->

    if Mywebroom.State.get('signInUser') and Mywebroom.State.get('signInUser').get('id')
      #Make Key Request
      requestModel = new Mywebroom.Models.CreateFriendRequestByUserIdAndUserIdRequestedModel()
      requestModel.set('userId', Mywebroom.State.get("signInUser").get("id"))
      requestModel.set('userIdRequested', idRequested)
      requestModel.save({}, {
        success: (model, response, options) ->
          #console.log('post requestKey SUCCESS', model)
        error: (model, xhr, options) ->
          console.error('post requestKey FAIL', xhr)
      })

      # Change style to Key requested
      if $('#profile_ask_for_key_overlay button').length is 1
        $requestButton = $('#profile_ask_for_key_overlay button')
        $requestButton.text("Key Requested")
        $requestButton.addClass("profile_key_requested").removeClass('profile_request_key_button')

      # Otherwise, change the style in your code :)

    else
      #send to landing page
      window.location.assign(window.location.protocol + "//" + window.location.host)




}
