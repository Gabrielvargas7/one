class Mywebroom.Views.RoomsIndex extends Backbone.View

  template: JST['rooms/index']
  events:{
  	'click #ProfileOpen':'showProfile',
  	
  }
  showProfile: (evt) ->
    #TODO Move this to the model initialize
    @profile = new Mywebroom.Models.ProfileHome({msg:"Hello user"})
    @profile.set(@theme_collection.models[0].get('user_profile'))
    @profile.set('user',@theme_collection.models[0].get('user'))
    @profile.set('user_photos',@theme_collection.models[0].get('user_photos'))
    
    @showProfileView()

    #I had a lot of issues when trying to create the Profile View here. 
    #Got a white screen on loading, no errors. 
    #Not sure why this wouldn't run if view is created right after model is.
    
  	#@profileView = new Mywebroom.Views.ProfileHomeView({model:@profile})
  	#$(@el).append(@profileView.el)
  	#@profileView.render()
  	#Need to stop listening to other room events (hover objects,etc)
    # Objects are initialized int room_router.js.coffee. how do I get that model to stop listening?
  	#Need to stop listening for click #ProfileOpen
  showProfileView: ->
    console.log("ShowProfileView fun")
    @profileView = new Mywebroom.Views.ProfileHomeView(
      model:@profile
      activityCollection:@activityCollection
      )
    $(@el).append(@profileView.el)
    @profileView.render()
  closeProfileView: ->
  	console.log('CloseProfileView Function running')
  	@profileView.remove();	
  	#Need to listen for #ProfileOpen again
  	#Need to enable other room events again.

  initialize: ->
    @collection.on('reset', @render, this)
    @theme_collection = new Mywebroom.Collections.RoomsJsonShowRoomByUserId()
    #@theme_colection.set('id',23)
    @theme_collection.fetch
      reset: true 
      success: (response)->
        console.log(response)
    #Can't get activity collection to wait for fetch if
    #it's in ProfileHomeModel
    @activityCollection = new Mywebroom.Collections.index_notification_by_limit_by_offset()
    @activityCollection.fetch
        reset:true
        limit:6
        offset:0
        success: (response)-> 
          console.log("ActivityCollection Fetched Successfully")
          console.log(response.attributes)
    #userid= @.get('user').id
    #@photosCollection = new Mywebroom.Collections.index_users_photos_by_user_id_by_limit_by_offset()
    #@photosCollection.fetch()

    #Tried putting this in the Profile Home model intialize function, but it was not ready for
    #view rendering -SN
    #@activityCollection = new Mywebroom.Collections.index_notification_by_limit_by_offset()
    #@activityCollection.fetch
    #    reset: true 
    #    success: (response)->
     #     console.log(response.attributes)

    #@profile.fetch({parse:true});
    #TODO Create Profile Model

#  render: ->
#    $(@el).html(@template(rooms1:"hi backbone -- wellcome to RoR "))
#    this

  render: ->
    $(@el).html(@template(user: @collection))
    #@theme_collection.fetch({reset: true})
    @themeView = new Mywebroom.Views.RoomThemeView(collection: @theme_collection)
    $('#c').append(@themeView.el)
    @themeView.render()
    this
