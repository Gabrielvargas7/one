class Mywebroom.Views.RoomsIndex extends Backbone.View

  template: JST['rooms/index']
  events:{
  	'click #ProfileOpen':'showProfile',
  	
  }
  showProfile: (evt) ->
    #evt.preventDefault()
  	@profileView = new Mywebroom.Views.ProfileHomeView({model:@profile});
  	$(@el).append(@profileView.el);
  	@profileView.render();
  	#Need to stop listening to other room events (hover objects,etc)
    # Objects are initialized int room_router.js.coffee. how do I get that model to stop listening?
  	#Need to stop listening for click #ProfileOpen
  
  closeProfileView: ->
  	console.log('CloseProfileView Function running')
  	@profileView.remove();	
  	#Need to listen for #ProfileOpen again
  	#Need to enable other room events again.

  initialize: ->
    @collection.on('reset', @render, this)
    @profile = new Mywebroom.Models.ProfileHome({msg:"Hello user"})
    @profile.fetch({parse:true});
    #TODO Create Profile Model

#  render: ->
#    $(@el).html(@template(rooms1:"hi backbone -- wellcome to RoR "))
#    this

  render: ->
    $(@el).html(@template(user: @collection))
    this
