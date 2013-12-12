Mywebroom.Helpers.AppHelper = {


  ###
  Determines if user is in a room
  Returns boolean
  ###
  isInARoom: ->

    path = window.location.pathname

    if path.split('/')[1] is 'room' and typeof path.split('/')[2] is "string" and path.split('/')[2].length > 0

      return true

    else

      return false







  ###
  DETERMINE IF USER IS SIGNED IN
  ###
  isSignedIn: ->

    isSignedInModel = new Mywebroom.Models.ShowIsSignedUserModel()
    isSignedInModel.fetch
      async: false
      success: (model, response, options) ->
        # console.log("signedIn fetch success", response)

      error: (model, response, options) ->
        console.error("isSigedIn model fetch fail", response.responseText)


    isSignedIn = isSignedInModel.get('signed')


    switch isSignedIn

      when "yes"
        return true

      when "not"
        return false

      else
        console.error("UNEXPECTED VALUE FOR ShowIsSignedeUserModel", isSignedIn)
        return false





  getRoomUser: ->

    # Set roomUser
    roomUsers = new Mywebroom.Collections.ShowRoomUserCollection()
    roomUsers.fetch
      async  : false
      success: (collection, response, options) ->
        # console.log("roomUser fetch success", response)
      error: (collection, response, options) ->
        console.error("roomUser fetch fail", response.responseText)


    roomUser = roomUsers.first()
    return roomUser




  getSignInUser: ->

    signInUsers = new Mywebroom.Collections.ShowSignedUserCollection()
    signInUsers.fetch
      async: false
      success: (collection, response, options) ->
        # console.log('signedUser collection fetch success', resposne)

      error: (collection, response, options) ->
        console.error('signInUsers collection fetch fail', response.responseText)


    signInUser = signInUsers.first()
    return signInUser






  getRoomData: (userId) ->

    dataCollection = new Mywebroom.Collections.ShowRoomByUserIdCollection()
    dataCollection.fetch({
      async: false
      url: dataCollection.url(userId)
      success: (collection, response, options) ->
        # console.log("roomData fetch success", resposne)

      error: (collection, response, options) ->
        console.error("roomData fetch fail", response.responseText)
    })


    dataModel = dataCollection.first()
    return dataModel



}
