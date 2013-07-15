class Mywebroom.Routers.Rooms extends Backbone.Router

  routes:
    '': 'routes_room'
    'show_room':'show_room'
  initialize: ->
#    @collection = new Mywebroom.Collections.ThemesJsonIndex()
    @signedUserInfoCollection = new Mywebroom.Collections.UsersJsonShowSignedUser()
    @theme_collection = new Mywebroom.Collections.RoomsJsonShowRoomByUserId()
    @signedUserInfoCollection.fetch({reset: true})
    @theme_collection.fetch({reset: true})
    @test_collection = new Mywebroom.Collections.RoomObjectsCollection()
    @test_collection.fetch({reset: true})


  routes_room: ->
    #Sanity Check View
    view = new Mywebroom.Views.RoomsIndex(collection: @signedUserInfoCollection)
    $('#c').html(view.render().el)
    #themeView in background
    themeView = new Mywebroom.Views.RoomThemeView(collection: @theme_collection)
    $('#c').append(themeView.render().el)
    objectsView = new Mywebroom.Views.RoomObjectView(collection: @test_collection)
    $('#c').append(objectsView.render().el)
    #for each object, we need to create a new Object View and render it in the room.
    #Or we need to create a collections view with all the objects in it.
  show_objects: ->
    objectsView = new Mywebroom.Views.RoomObjectView(collection: @test_collection)
    $('#c').append(objectsView.render().el)
  show_room: ->
    alert("Show the room theme")





