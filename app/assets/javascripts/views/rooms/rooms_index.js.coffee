class Mywebroom.Views.RoomsIndex extends Backbone.View

  template: JST['rooms/index']
  events:{
  	'click #ProfileOpen':'showProfile',
  	
  }
  showProfile: ->
  	@profileView = new Mywebroom.Views.ProfileHomeView({model:@profile});
  	$(@el).append(@profileView.el);
  	@profileView.render();
  
  closeProfileView: ->
  	console.log('CloseProfileView Function running')
  	@profileView.remove();	




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
