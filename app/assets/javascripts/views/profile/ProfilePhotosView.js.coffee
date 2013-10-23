class Mywebroom.Views.ProfilePhotosView extends Backbone.View
  tagName:'div'
  className:'user-photos-view'
  template: JST['profile/ProfilePhotosTemplate']
  events:
    'click .profile_request_key_button':'askForKey'

  initialize: ->
    @photosCollection = new Mywebroom.Collections.IndexUsersPhotosByUserIdByLimitByOffsetCollection()
    #If global flag, fetch 9 instead
    fetchLimit = 24
    @photosCollection.fetch
        url: @photosCollection.url @model.get('user_id'),fetchLimit,0
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
    #if(@model.get F"LAG_PROFILE" is Mywebroom.Views.RoomView.PUBLIC_ROOM)
    #if @photosCollection.length > 6
    # $(@el).append(JST['profile/ProfileAskForKey']())
    this
  askForKey:(event)->
    #Key Request. 
    Mywebroom.Helpers.RequestKey(@model.get('user_id'))