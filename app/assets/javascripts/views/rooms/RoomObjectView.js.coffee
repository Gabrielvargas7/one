class Mywebroom.Views.RoomObjectView extends Backbone.View
  className: 'room_object'
  template: JST['rooms/roomObject']
  initialize: ->
    @collection.on('reset',@render,this)

  render: ->
    attribute = this.collection.toJSON()
    if attribute.length>0
        @user_objects=attribute[0].user_items_designs
        console.log("Objects Array user_objects passed to templates"+ @user_objects)
        #(@el).html(@template(room_object: @collection))
        $(@el).html(@template(room_object: @user_objects))     #pass variables into template.
    this

#class Mywebroom.Views.RoomObjectView extends Backbone.View
#  className: 'user_objects'
#  template: JST['rooms/roomObject']
#  initialize: ->
#    @collection.on('reset',@render,this)
#
#  render: ->
#    attribute = this.collection.toJSON()
#    if attribute.length>0
#      @user_objects=attribute[0].user_items_designs
#      console.log("Objects Array user_objects passed to templates"+ @user_objects)
#      $(@el).html(@template(user_objects: @collection))     #pass variables into template.
#      this

