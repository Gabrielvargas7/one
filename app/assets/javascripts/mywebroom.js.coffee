window.Mywebroom =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: ->
        new Mywebroom.Routers.RoomsRouter()
        Backbone.history.start()

$(document).ready ->
  Mywebroom.initialize()
