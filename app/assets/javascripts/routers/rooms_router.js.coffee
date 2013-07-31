class Mywebroom.Routers.Rooms extends Backbone.Router

  routes:
    '': 'routes_room'
    '/room/:name': 'show_room'
    'show_room':'show_room'
  initialize: ->
#    @collection = new Mywebroom.Collections.ThemesJsonIndex()
    @signedUserInfoCollection = new Mywebroom.Collections.UsersJsonShowSignedUser()
    @theme_collection = new Mywebroom.Collections.RoomsJsonShowRoomByUserId()
    @signedUserInfoCollection.fetch({reset: true})
    @theme_collection.fetch({reset: true})

  routes_room: (name) ->
    #Sanity Check View
    view = new Mywebroom.Views.RoomsIndex(collection: @signedUserInfoCollection)
    $('#c').html(view.render().el)
    #themeView in background
    themeView = new Mywebroom.Views.RoomThemeView(collection: @theme_collection)
    $('#c').append(themeView.render().el)
  show_objects: ->
    objectsView = new Mywebroom.Views.RoomObjectView(collection: @test_collection)
    $('#c').append(objectsView.render().el)
  show_room: (name)->
    alert("Show the name #{name}")





