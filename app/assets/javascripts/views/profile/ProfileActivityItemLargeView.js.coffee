class Mywebroom.Views.ActivityItemLargeView extends Backbone.View
	template: JST['profile/ProfileActivityItemLargeTemplate']
	className: 'activity_item_large_wrap'
	initialize: ->
		 _.bindAll this, 'insideHandler', 'outsideHandler'
	render: ->
		$('body').on('click', this.outsideHandler);
		$(@el).html(@template(model:@model))
		#The social View is in the template because
		#the styling was not right with this view. It needs a parent wrapper div, and the 
		#social view cannot append elegantly with the current styling.
		#Revisit if we use a Backbone Layout Plugin like SubViews or Marionette.
		# #append social view to el here
		# socialBarView = new Mywebroom.Views.SocialBarView({model:@model})
		# $(@el).append(socialBarView.el)
		# socialBarView.render()

		
		this
	insideHandler: (event) ->
		event.stopPropagation()
		console.log "insideHandler called"
	outsideHandler: ->
		console.log "outsideHandler called"
		@closeView()
		return false
	closeView: ->
		$('body').off('click', this.outsideHandler);
		#change profile_drawer widths back to original
		$("#profile_drawer").css "width", "760px"
		this.$el.remove()
		console.log "ActivityItemLargeView closed"
		this
class Mywebroom.Views.GenericOuterDiv extends Backbone.View
	render: ->
		$(@el).html("")
		this