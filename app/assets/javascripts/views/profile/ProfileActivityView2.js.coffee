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
		this.on('itemview:gridItemLargeView',@showGridItemLargeView)
	#The Marionette way to pass additional data to template:
	#Override serializeData method to pass additional data to this template. 
	serializeData:->
		viewData= {}
		viewData.headerName = if @options.headerName is `undefined` then true else @options.headerName
		viewData
	showGridItemLargeView:(childView,model)->
  		currentGridItem = model
  		#launch new view. profile_drawer needs to expand
   		#CHeck if there's a currentView and remove it if so.
  		#(This is possible when clicking next and prev item from large view)
  		if @currentView
  			@currentView.closeView()
  			@currentView.remove()
  			@currentModelIndex=undefined
  		if currentGridItem.collection.constructor.name is Mywebroom.Collections.IndexUsersPhotosByUserIdByLimitByOffsetCollection.name
  		 	@currentView= new Mywebroom.Views.PhotosLargeView({model:currentGridItem})
  		else
  			@currentView = new Mywebroom.Views.ActivityItemLargeView({model:currentGridItem,collection:@collection})
  			@currentView.on('ProfileActivityLargeView:showNext',@showNextItem,this)
  			$("#profile_home_wrapper").append(@currentView.el)
  			$("#profile_drawer").css "width", "1320px"
  			@currentView.render()
  	showNextItem:(event,model)->
  			console.log 'lets event here instead'
  			oldModel = model
  			#get next model
  			@currentModelIndex = @collection.indexOf(oldModel) if !@currentModelIndex
  			if event.currentTarget.id is "large_item_next"
  				newModel = @collection.at(@currentModelIndex+1);
  				@currentModelIndex++ if newModel
  			else
  				newModel = @collection.at(@currentModelIndex-1);
  				@currentModelIndex-- if newModel
  			if newModel
  				#close current view
  				@currentView.closeView() if @currentView
  				@currentView.remove() if @currentView
  				#open new view
  				$("#profile_drawer").css "width", "1320px" 
  				@currentView = new Mywebroom.Views.ActivityItemLargeView({model:newModel,collection:@collection,originalCollection:@originalCollection})
  				@currentView.on('ProfileActivityLargeView:showNext',@showNextItem,this)
  				$("#profile_home_wrapper").append(@currentView.el)
  				@currentView.render() 

#When the itemView prototype is set, 
#Mywebroom.Views.ProfileGridItemView2 does not exist yet.
#That's why itemView is initially set to undefined.  
#SOLUTION: Make itemView a function. 
		
