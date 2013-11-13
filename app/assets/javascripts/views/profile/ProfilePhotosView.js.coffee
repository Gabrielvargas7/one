class Mywebroom.Views.ProfilePhotosView extends Backbone.View
  tagName:'div'
  className:'user-photos-view'
  template: JST['profile/ProfilePhotosTemplate']
  events:
    'click .profile_request_key_button':'askForKey'

  initialize: ->
    @photosCollection = new Mywebroom.Collections.IndexUsersPhotosByUserIdByLimitByOffsetCollection()
    #If global flag, fetch 9 instead
    @fetchLimit = 9
    @offset=0
    @photosCollection.fetch
        url: @photosCollection.url @model.get('user_id'),@fetchLimit,0
        async:false
        success: (response)->
         console.log("PhotosCollection Fetched Successfully")
         console.log(response)
    if(@model.get("FLAG_PROFILE") is "PUBLIC")
     @photosCollection.reset(@photosCollection.first(9), silent:true)
  
  render: ->
    #FOR TESTING ONLY- set flag profile
    #@model.set 'FLAG_PROFILE', Mywebroom.Views.RoomView.PUBLIC_ROOM
    $(@el).html(@template(collection:@photosCollection, model:@model))
    #create table with data
    tableView = new Mywebroom.Views.ProfileActivityView2(collection: @photosCollection, model:@model)
    $(@el).append(tableView.render().el)

    if @photosCollection.length is @fetchLimit
      #set scroll event to fetch more photos. Try creating new tableview and appending it to the el. 
      that = this
      @$('#gridItemList').off('scroll').on('scroll',that, (event)-> 
        if $('#gridItemList').scrollTop() + $('#gridItemList').innerHeight() >= $('#gridItemList')[0].scrollHeight-10
          event.data.paginate(event)
          )


    this
  
  askForKey:(event)->
    #Key Request if a public user visits this page. 
    Mywebroom.Helpers.RequestKey(@model.get('user_id'))
  
  paginate:(event)->
    #Need Photos Total
    event.preventDefault()
    event.stopPropagation()

    #Turn off scroll so multiple scrolls don't fetch multiple times
    @$('#gridItemList').off('scroll')
    
    #1. Increment offset
    event.data.offset += event.data.fetchLimit;

    #2. Fetch new items
    nextCollection = new Mywebroom.Collections.IndexUsersPhotosByUserIdByLimitByOffsetCollection()
    nextCollection.fetch
        url: @photosCollection.url event.data.model.get('user_id'),event.data.fetchLimit,event.data.offset
        async:false
        success: (response)->
         console.log("PhotosCollection Fetched Successfully")
         console.log(response)
    
    #3. Render the new data's view.
    if nextCollection
      #3a. Add to collection and Marionette- ProfileActivityView2 will auto render it. Yay! 
      event.data.photosCollection.add(nextCollection.toJSON())
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
        if $('#gridItemList').scrollTop() + $('#gridItemList').innerHeight() >= $('#gridItemList')[0].scrollHeight-10
          event.data.paginate(event)
          )
