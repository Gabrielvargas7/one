class Mywebroom.Views.RoomThemeView extends Backbone.View
  className: 'user_theme'
  template: JST['rooms/roomTheme']
  initialize: ->
    @collection.on('reset',@render,this)
    #Child initialize
    @object_collection = new Mywebroom.Collections.RoomObjectsCollection()
    @object_collection.fetch({reset: true,parse:true})

  render: ->
    attribute = this.collection.toJSON()
    console.log(attribute)
    $(@el).html(@template(user_theme: @collection))     #pass variables into template.
    #Create Objects View within Theme
    objectsView = new Mywebroom.Views.RoomObjectView(collection: @object_collection)
    $('#room_theme_container').append(objectsView.render().el)

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

