class Mywebroom.Views.PhotosLargeView extends Backbone.View
	template: JST['profile/PhotosLarge']
	className: 'photos_large_view'
	events:
		"click #photos_next":"insideHandler"
		"click #photos_prev":"insideHandler"
	initialize: ->
		 _.bindAll this, 'insideHandler', 'outsideHandler'
	render: ->
		$('body').on('click', this.outsideHandler);
		$(@el).html(@template(model:@model))
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
		#change profile_draw widths back to original
		$("#profile_drawer").css "width", "760px"
		this.$el.remove()
		console.log "PhotosLargeView closed"
		this
		