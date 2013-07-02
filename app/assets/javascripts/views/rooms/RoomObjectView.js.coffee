class Mywebroom.Views.RoomObjectView extends Backbone.View
  className: 'room_object'
  template: JST['rooms/roomObject']
  initialize: ->
    @collection.on('reset',@render,this)

  render: ->
    attribute = this.collection.toJSON()
    user_objects=attribute[0].user_item_designs
    console.log("Objects Array "+ @user_objects)
    $(@el).html(@template(user_objects: @user_objects))     #pass variables into template.
    this

