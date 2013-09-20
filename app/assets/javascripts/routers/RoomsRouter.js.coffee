class Mywebroom.Routers.RoomsRouter extends Backbone.Router

  routes:
    '': 'routesRoom'

  initialize: ->

  routesRoom: ->
    view = new Mywebroom.Views.RoomView()
    $('#xroom_main_container').append(view.render().el)
