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
    collection.fetch
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



              window.lightbox('lightbox-ins', 'lightbox-shadow-ins')


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

}

