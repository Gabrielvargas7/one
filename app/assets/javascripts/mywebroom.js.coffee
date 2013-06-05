window.Mywebroom =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: ->
        new Mywebroom.Routers.Rooms()
        Backbone.history.start()

$(document).ready ->
  Mywebroom.initialize()
