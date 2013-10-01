class Mywebroom.Routers.RoomsRouter extends Backbone.Router

  routes:
    "": "routesRoom"


  routesRoom: ->
    # Create the main view
    view = new Mywebroom.Views.RoomView()
    
    # FIXME - This isn't necessary because RoomView() isn't so much a view as a setup method
    # Render and attach to main div
    # Mywebroom.App.xroom_main_container.show(view)
