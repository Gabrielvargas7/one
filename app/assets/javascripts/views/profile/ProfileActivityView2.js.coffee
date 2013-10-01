class Mywebroom.Views.ProfileActivityView2 extends Marionette.CompositeView
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
		viewData.headerName = @options.headerName
		viewData
	#OnRender is called after built in render function has completed.
	onRender:->
		if @model and @model.get('FLAG_PROFILE') is "PUBLIC"
			#append ask for key overlay.
			@$(@itemViewContainer).append(JST['profile/ProfileAskForKey']())
	showGridItemLargeView:(childView,model)->
		currentGridItem = model
		#launch new view. profile_drawer needs to expand
		#CHeck if there's a currentView and remove it if so.
		#(This is possible when clicking next and prev item from large view)
		if @currentView
			@currentView.closeView()
			@currentView.remove()
			@currentModelIndex=undefined
		@currentView = new Mywebroom.Views.ActivityItemLargeView({model:currentGridItem,collection:@collection})
		@currentView.on('ProfileActivityLargeView:showNext',@showNextItem,this)
		$("#profile_home_wrapper").append(@currentView.el)
		@currentView.render()

	showNextItem:(event,model)->
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
				@currentView = new Mywebroom.Views.ActivityItemLargeView({model:newModel,collection:@collection,originalCollection:@originalCollection})
				@currentView.on('ProfileActivityLargeView:showNext',@showNextItem,this)
				$("#profile_home_wrapper").append(@currentView.el)
				@currentView.render() 

#When the itemView prototype is set, 
#Mywebroom.Views.ProfileGridItemView2 does not exist yet.
#That's why itemView is initially set to undefined.  
#SOLUTION: Make itemView a function. 
		
