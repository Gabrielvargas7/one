class Mywebroom.Views.MyBookmarksView extends Backbone.View
	#*******************
	#**** Tag  (no tag = default el "div")
	#*******************
	
	className:"my_bookmarks_list_wrap"
	#*******************
	#**** Initialize
	#*******************
	initialize:->
		@template=this.options.template if this.options.template
		@collection.on('add', this.render, this);
		@collection.on('reset', this.render, this);
	#*******************
	#**** Templeate
	#*******************
	template:JST['bookmarks/MyBookmarksTemplate']
	
	#*******************
    #**** Render
    #*******************
	
	render:->
		@$el.empty()
		$(@el).append(@template())
		 
		#Split collection into rows of five
		# and send them to <ul>. Then make <li> for each
		@appendItems()
		this
	
	#*******************
	#**** Functions  
	#*******************
	
	#--------------------------
	# append bookmark items to this view. called from render()
	#--------------------------
	appendItems:->
		#Divide collection into rows of 5. 
		#Insert ul element. 
		#For each in 5ple, append a grid item view. 
		k=0
		columnNum=5
		rowArray= []
		console.log("@collection.models.length: "+@collection.models.length)
		while k < @collection.models.length
		  i = 0
		  while i < columnNum
		    rowArray.push @collection.at k  if k < @collection.models.length
		    k+=1
		    i++
		  #Make into ul
		  rowNum= k/columnNum
		  rowLine = "<ul id='my_bookmarks_row_item_"+rowNum+"'></ul>"
		  @$('.my_bookmarks_bottom').append rowLine
		  #Now do for each in rowArray, new GridItem view and append to rowView
		  for bookmark in rowArray
		  	bookmarkItemView = new Mywebroom.Views.MyBookmarkGridItemView(model:bookmark)
		  	@$('#my_bookmarks_row_item_'+rowNum).append(bookmarkItemView.el)
		  	bookmarkItemView.render()
		  	#this.$('#my_bookmarks_row_item'+rowNum).append(bookmarkItemView.render().el)
		  rowArray.length = 0

