class Mywebroom.Views.MyBookmarksView extends Backbone.View
  #*******************
  #**** Tag  / Class
  #*******************
  
  className:"my_bookmarks_list_wrap"
  #*******************
  #**** Initialize
  #*******************
  initialize:->
    @template=this.options.template if this.options.template
    @collection.on('add', this.render, this);
    @collection.on('reset', this.render, this);
    @collection.on('remove',this.render,this)
    #@collection.on('deleteBookmark',@triggerDeleteBookmark,this)
  #*******************
  #**** Template
  #*******************
  template:JST['bookmarks/MyBookmarksTemplate']
  
  #*******************
    #**** Render
    #*******************
  
  render:->
    @$el.empty()
    $(@el).append(@template())
    #Add the "MORE" square to the collection
    moreSquare = new Backbone.Model({title:"MYWEBROOM_LAST"})
    @collection.add(moreSquare,{silent:true})
    @appendItems()
    @collection.remove(moreSquare,{silent:true})
    this
  
  #*******************
  #**** Functions  
  #*******************
  
  #--------------------------
  # append bookmark items to this view. called from render(). Views here listen for deleteBookmark event.
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
        bookmarkItemView.on('deleteBookmark',@triggerDeleteBookmark,this)
        #this.$('#my_bookmarks_row_item'+rowNum).append(bookmarkItemView.render().el)
      rowArray.length = 0

  #--------------------------
  # Delete the bookmark from the server. Called when user confirms delete a bookmark in modal.
  #   
  #--------------------------
  triggerDeleteBookmark:(model)->
    bookmarkId= model.get('id')
    position= model.get('position')
    userId= @getUserSignedInId()
    deletedBookmark = new Mywebroom.Models.DestroyUserBookmarkByUserIdBookmarkIdAndPosition()
    deletedBookmark.set 'url', deletedBookmark.url(userId,bookmarkId,position)
    #Delete the bookmark from the server. 
    deletedBookmark.destroyUserBookmark()
    #destroy the modal
    $('#myModal').remove()

  #--------------------------
  # Get the current signed in user. Called from triggerDeleteBookmark
  #--------------------------
  getUserSignedInId:->
    userSignInCollection = new Mywebroom.Collections.ShowSignedUserCollection()
    userSignInCollection.fetch async: false
    userSignInCollection.models[0].get('id')

  triggerBrowseMode:(model)->
    console.log "BrowseMode triggered in MyBookmarksView:"
    console.log model
    this.trigger('browseMode1',model)

