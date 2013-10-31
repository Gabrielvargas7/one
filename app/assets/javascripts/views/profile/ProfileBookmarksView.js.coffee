class Mywebroom.Views.ProfileBookmarksView extends Backbone.View
  template:JST['profile/ProfileBookmarksTemplate']
  className: "profile_bookmarks_view"
  events:
    'click .profile_request_key_button':'askForKey'

  initialize: ->
    @bookmarksCollection = new Mywebroom.Collections.IndexUserBookmarksByUserIdCollection()
    
    @bookmarksCollection.fetch
      url:@bookmarksCollection.url @model.get('user_id')
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
    this

  askForKey:(event)->
    #Key Request. 
    Mywebroom.Helpers.RequestKey(@model.get('user_id'))