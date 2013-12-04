class Mywebroom.Views.ProfileObjectsView extends Backbone.View
  className:'profile_objects_view'
  template: JST['profile/ProfileObjectsTemplate']
  initialize: ->
    
    @fetchLimit = 24
    @offset = 0

    #Note: previously, we were sending in the collection of objects. 
    #We should just fetch the collection initially since this is what we'll do in the future 
    @collection = new Mywebroom.Collections.IndexUserItemsDesignsByUserIdByLimitAndOffset()
    @collection.fetch
        url: @collection.url @model.get('user_id'),@fetchLimit,@offset
        async:false
        success: (response)->
    if(@model.get("FLAG_PROFILE") is "PUBLIC")
     @collection.reset(@collection.first(9), silent:true)

    


  events:
    'click .profile_request_key_button':'askForKey'

  render: ->
    $(@el).html(@template(collection: @collection,model:@model))
    #append objects table.
    if Mywebroom.State.get('roomData').get('user_profile').firstname
      headerName = Mywebroom.State.get('roomData').get('user_profile').firstname + "'s OBJECTS"
    else
      headerName = Mywebroom.State.get('roomData').get('user').username + "'s OBJECTS"
    objectsTableView = new Mywebroom.Views.ProfileActivityView2(collection: @collection, model:@model,headerName:headerName)
    $(@el).append(objectsTableView.render().el)
    if @collection.length is @fetchLimit
      #set scroll event to fetch more objects. Try creating new tableview and appending it to the el.
      that = this
      @$('#gridItemList').off('scroll').on('scroll',that, (event)->
        if $('#gridItemList').scrollTop() + $('#gridItemList').innerHeight() >= $('#gridItemList')[0].scrollHeight-100
          event.data.paginate(event)
        )
    this

  askForKey:(event)->
    #Key Request.
    Mywebroom.Helpers.RequestKey(@model.get('user_id'))

  paginate:(event)->
    #Need Objects Total
    event.preventDefault()
    event.stopPropagation()

    #Turn off event so fast scroll doesn't trigger multiple fetches
    event.data.$('#gridItemList').off('scroll')
    #1. Increment offset
    event.data.offset += event.data.fetchLimit;

    #2. Fetch new items
    nextCollection = new Mywebroom.Collections.IndexUserItemsDesignsByUserIdByLimitAndOffset()
    nextCollection.fetch
        url: nextCollection.url event.data.model.get('user_id'),event.data.fetchLimit,event.data.offset
        async:false
        success: (response)->
          #console.log("Friend Objects Fetched Successfully")
          #console.log(response)

    #3. Render the new data's view.
    if nextCollection
      #3a. Add to collection and Marionette- ProfileActivityView2 will auto render it. Yay!
      event.data.collection.add(nextCollection.toJSON())
      # nextCollection.each((item)->
      #   itemView = new Mywebroom.Views.ProfileGridItemView2(model:item)
      #   $('#gridItemList').append(itemView.render().el)
      #   )

    #4. if no data was fetched, turn off event.
    if !nextCollection.models.length or nextCollection.models.length < event.data.fetchLimit
      event.data.$('#gridItemList').off('scroll');
    else
      that = this
      $('#gridItemList').off('scroll').on('scroll',that, (event)->
        if $('#gridItemList').scrollTop() + $('#gridItemList').innerHeight() >= $('#gridItemList')[0].scrollHeight-100
          event.data.paginate(event)
        )
