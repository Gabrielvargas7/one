class Mywebroom.Views.ProfileActivityView2 extends Marionette.CompositeView
	#el:"#profileActivityTable"
	tagName:'div'
	className: 'profileHome_activity generalGrid'
	template: JST['profile/ProfileHomeGridTemplate2']
	itemView:(obj) ->
		new Mywebroom.Views.AProfileGridItemView2(obj)
	itemViewContainer:'#gridItemsTest'
	
	initialize: ->
		@headerName=this.options.headerName

#When the itemView prototype is set, 
#Mywebroom.Views.ProfileGridItemView2 does not exist yet.
#That's why itemView is initially set to undefined.  
		
