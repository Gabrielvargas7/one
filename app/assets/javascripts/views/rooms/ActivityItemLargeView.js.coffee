class Mywebroom.Views.ActivityItemLargeView extends Backbone.View
	template: JST['profile/ActivityItemLarge']
	className: 'activity_item_large_view'
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
		console.log "ActivityItemLargeView closed"
		this
