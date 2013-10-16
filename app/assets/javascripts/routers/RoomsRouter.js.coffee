class Mywebroom.Routers.RoomsRouter extends Backbone.Router

  routes:
    '': 'routesRoom'
    # is dont find the route just the default
    '*default':'routesRoom'


  routesRoom: ->
    # Create the main view
    view = new Mywebroom.Views.RoomView()
    
    # Save a reference in the state model
    Mywebroom.State.set("roomView", view)
    
    # FIXME - This isn't necessary because RoomView() isn't so much a view as a setup method
    # Render and attach to main div
    # Mywebroom.App.xroom_main_container.show(view)
