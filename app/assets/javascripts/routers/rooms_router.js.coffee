class Mywebroom.Routers.Rooms extends Backbone.Router

  routes:
    '': 'routes_room'

  initialize: ->
#    @collection = new Mywebroom.Collections.ThemesJsonIndex()
    @collection = new Mywebroom.Collections.UsersJsonShowSignedUser()
    @collection.fetch({reset: true})


  routes_room: ->
#    alert "room backbone router "
    view = new Mywebroom.Views.RoomsIndex(collection: @collection)
    $('#c').html(view.render().el)




