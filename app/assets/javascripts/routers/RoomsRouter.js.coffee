class Mywebroom.Routers.Rooms extends Backbone.Router

  routes:
    '': 'routes_room'
    'xroom': 'routesRoom'


  initialize: ->
#    @collection = new Mywebroom.Collections.ThemesJsonIndex()
    @signedUserInfoCollection = new Mywebroom.Collections.UsersJsonShowSignedUser()
    #@theme_collection = new Mywebroom.Collections.RoomsJsonShowRoomByUserId()
    @signedUserInfoCollection.fetch({reset: true})
    #@theme_collection.fetch({reset: true})

  routes_room: ->
    view = new Mywebroom.Views.RoomView(collection: @signedUserInfoCollection)
    $('#xroom_main_container').append(view.render().el)


  routesRoom: ->
    xRoomView = new Mywebroom.Views.XRoomView()
    $('#xroom_main_container').append(xRoomView.render().el)






