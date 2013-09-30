class Mywebroom.Routers.RoomsRouter extends Backbone.Router

  routes:
    "": "routesRoom"


  routesRoom: ->
    # Create the main view
    view = new Mywebroom.Views.RoomView()
    
    # Render and attach to main div
    Mywebroom.App.xroom_main_container.show(view)

