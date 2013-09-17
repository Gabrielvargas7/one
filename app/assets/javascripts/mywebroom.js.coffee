window.Mywebroom =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  Helpers:{}

  initialize: ->
        new Mywebroom.Routers.RoomsRouter()
        Backbone.history.start()

$(document).ready ->
  Mywebroom.vent = _.extend({}, Backbone.Events)
  Mywebroom.initialize()
