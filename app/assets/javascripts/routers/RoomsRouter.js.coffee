class Mywebroom.Routers.Rooms extends Backbone.Router

  routes:
    '': 'routes_room'

  initialize: ->

  routes_room: ->
    view = new Mywebroom.Views.RoomView()
    $('#xroom_main_container').append(view.render().el)








