class Mywebroom.Routers.Rooms extends Backbone.Router

  routes:
    '': 'routes_room'
#    'xroom': 'routesRoom'


  initialize: ->

  routes_room: ->
    view = new Mywebroom.Views.RoomView()
    $('#xroom_main_container').append(view.render().el)


#  routesRoom: ->
#    xRoomView = new Mywebroom.Views.XRoomView()
#    $('#xroom_main_container').append(xRoomView.render().el)






