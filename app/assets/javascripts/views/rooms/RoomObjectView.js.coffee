class Mywebroom.Views.RoomObjectView extends Backbone.View
  #className: 'room_object'
  template: JST['rooms/roomObject']
  events:
    'click .room_object':'displayObject'
    'mouseenter img.room_object':'hoverObject'
    'mouseleave img.room_object':'hoverOffObject'

  initialize: ->
    #Commented out because Theme handles this one for now. -SN
    #@collection.on('reset',@render,this)

  render: ->
    #@user_objects=attribute[0].user_items_designs
    #console.log("Objects Array user_objects passed to templates"+ @user_objects)
    #Consider iterating the collection here and appending separate views -SN
    #(@el).html(@template(room_object: @collection))
    for roomObject in @collection.models
      $(@el).append(@template(room_object: roomObject))
         #pass variables into template.
    this

  displayObject: (event) ->
    currentObj = this.collection.get(event.currentTarget.dataset.id)
    alert("You clicked an object: #{currentObj.get('items_name')}")
    #Get name. Can either include it in template as ID. Or use an API to grab the info of that item. Get user's bed for example
  hoverObject: (event) ->
    #change out images displayed. 
    dataID= event.currentTarget.dataset.id
    hovered = this.collection.get(dataID)
    $('[data-id='+dataID+']').attr('src',hovered.get('image_name_hover').url)
  hoverOffObject: (event) ->
    dataID= event.currentTarget.dataset.id
    hovered = this.collection.get(dataID)
    $('[data-id='+dataID+']').attr('src',hovered.get('image_name').url)




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

