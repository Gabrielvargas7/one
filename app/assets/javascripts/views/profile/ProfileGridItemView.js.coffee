class Mywebroom.Views.ProfileGridItemView extends Backbone.View
	tagName:'td'
	className:'gridItem'
	template:JST['profile/ProfileGridItemTemplate']
	render: ->
		if @model.get('title') != undefined
		#if @model.collection.constructor.name is Mywebroom.Collections.IndexUserBookmarksByUserIdCollection.name
			gridText = @model.get('title')
		else
			gridText= @model.get('name')
		$(@el).html(@template(model:@model,gridText:gridText))
	events: 
		'mouseenter .gridItem':'showSocialBarView' 
		'mouseleave .gridItem':'closeSocialBarView'
		'click .gridItem':'getGridItemModel'
	showSocialBarView:(event)->
  		hoveredModel = @model
  		#Depending on FLAG_PROFILE, hover will cause different view here. 
  		@socialBarView = new Mywebroom.Views.SocialBarView(model:hoveredModel)
  		$(@el).children(".gridItem").children(".gridItemPicture").append(@socialBarView.el)
  		@socialBarView.render() 
 	closeSocialBarView:->
  		@socialBarView.remove()
	getGridItemModel: (event) ->
		event.stopPropagation()
		dataID = event.currentTarget.dataset.id
		console.log("You clicked a grid Item in ProfileGridItemView " +this.model.get('id'))
		#gridItem is either Activity Item or Photo. Determine which. 
		currentGridItem = this.model
		#launch new view. profile_drawer needs to expand
		$("#profile_drawer").css "width", "1320px"
		#$("#profile_home_container").css "width", "1320px"
    #if currentGridItem is photos, we want a PhotosView. otherwise, we want an ActivityView.
    #if currentGridItem's Collection is this view's parent's @photosCollection, create a Photos View. 
		if currentGridItem.collection.constructor.name is Mywebroom.Collections.IndexUsersPhotosByUserIdByLimitByOffsetCollection.name
      		currentView= new Mywebroom.Views.PhotosLargeView({model:currentGridItem})
	    else
	      	currentView = new Mywebroom.Views.ActivityItemLargeView({model:currentGridItem})
			$("#profile_home_wrapper").append(currentView.el)
			currentView.render()  
