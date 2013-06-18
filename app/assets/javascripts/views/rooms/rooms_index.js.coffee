class Mywebroom.Views.RoomsIndex extends Backbone.View

  template: JST['rooms/index']

  initialize: ->
    @collection.on('reset', @render, this)

#  render: ->
#    $(@el).html(@template(rooms1:"hi backbone -- wellcome to RoR "))
#    this

  render: ->
    $(@el).html(@template(user: @collection))
    this
