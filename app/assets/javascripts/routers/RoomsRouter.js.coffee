class Mywebroom.Routers.RoomsRouter extends Backbone.Router

  routes:
    '': 'routesRoom'


  routesRoom: ->
    view = new Mywebroom.Views.RoomView()
    
    Mywebroom.App.xroom_main_container.show(view)
    
    #$('#xroom_main_container').append(view.render().el)

