class Mywebroom.Views.ProfileActivityView2 extends Marionette.CompositeView
	#el:"#profileActivityTable"
	tagName:'div'
	className: 'profileHome_activity generalGrid'
	template: JST['profile/ProfileHomeGridTemplate2']
	itemView:Mywebroom.Views.ProfileGridItemView2
	itemViewContainer:'#gridItemsTest'
	
	initialize: ->
		@headerName=this.options.headerName
		
	render: ->
		#this template will be the parent one which defines the table
		$(@el).html(@template(headerName:@headerName))
		this