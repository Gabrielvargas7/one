class Mywebroom.Views.ProfileBookmarksView extends Backbone.View
  template:JST['profile/ProfileBookmarksTemplate']
  className: "profile_bookmarks_view"
  events:
    'click .profile_request_key_button':'askForKey'

  initialize: ->
    @fetchLimit = 24
    @offset = 0

    @bookmarksCollection = new Mywebroom.Collections.IndexUserBookmarksByUserIdByLimitAndOffset()
    
    @bookmarksCollection.fetch
      url:@bookmarksCollection.url @model.get('user_id'), @fetchLimit, @offset
      async:false
      success: (response)->
        console.log("UsersBookmarks fetched success:")
        console.log(response) 
    if(@model.get("FLAG_PROFILE") is "PUBLIC")
     @bookmarksCollection.reset(@bookmarksCollection.first(9), silent:true)
    
    @bookmarksGridView = new Mywebroom.Views.ProfileActivityView2(collection:@bookmarksCollection,model:@model,headerName:"Bookmarks")

  render:->
    $(@el).html(@template(model:@model))
    #$(@el).append(JST['profile/ProfileGridTableHeader'](headerName:"Bookmarks"))
    $(@el).append(@bookmarksGridView.render().el)

    if @bookmarksCollection.length is @fetchLimit
      #set scroll event to fetch more . Try creating new tableview and appending it to the el. 
      that = this
      @$('#gridItemList').off('scroll').on('scroll',that, (event)-> 
        if $('#gridItemList').scrollTop() + $('#gridItemList').innerHeight() >= $('#gridItemList')[0].scrollHeight-50
          event.data.paginate(event)
          )

    this

  askForKey:(event)->
    #Key Request. 
    Mywebroom.Helpers.RequestKey(@model.get('user_id'))

  paginate:(event)->

    $('#gridItemList').off('scroll')
    
    event.preventDefault()
    event.stopPropagation()
    #1. Increment offset
    event.data.offset += event.data.fetchLimit;

    #2. Fetch new items
    nextCollection = new Mywebroom.Collections.IndexUserBookmarksByUserIdByLimitAndOffset()
    nextCollection.fetch
        url: @bookmarksCollection.url event.data.model.get('user_id'),event.data.fetchLimit,event.data.offset
        async:false
        success: (response)->
         console.log("bookmarksCollection Fetched Successfully")
         console.log(response)
    
    #3. Render the new data's view.
    if nextCollection
      #3a. Add to collection and Marionette- ProfileActivityView2 will auto render it. Yay! 
      event.data.bookmarksCollection.add(nextCollection.toJSON())
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
        if $('#gridItemList').scrollTop() + $('#gridItemList').innerHeight() >= $('#gridItemList')[0].scrollHeight-50
          event.data.paginate(event)
          )
