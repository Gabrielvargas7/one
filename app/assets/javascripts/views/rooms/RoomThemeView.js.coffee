class Mywebroom.Views.RoomThemeView extends Backbone.View
  className: 'user_theme'
  template: JST['rooms/roomTheme']
  initialize: ->
    @collection.on('reset',@render,this)

  render: ->
    attribute = this.collection.toJSON()
    console.log(attribute)
    $(@el).html(@template(user_theme: @collection))     #pass variables into template.
    this
#  template: JST['rooms/index']
#
#initialize: ->
#  @collection.on('reset', @render, this)
#
##  render: ->
##    $(@el).html(@template(rooms1:"hi backbone -- wellcome to RoR "))
##    this
#
#render: ->
#  $(@el).html(@template(user: @collection))
#  this