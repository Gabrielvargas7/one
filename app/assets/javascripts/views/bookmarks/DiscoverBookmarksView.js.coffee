class Mywebroom.Views.DiscoverBookmarksView extends Marionette.CompositeView #Backbone.View

  template: JST['bookmarks/DiscoverBookmarksTemplate']

  className: 'discover_list_wrap'

  itemView:(obj)->
    new Mywebroom.Views.DiscoverBookmarkGridItemView(obj)

  itemViewContainer:'.discover_bookmarks_list'

  onRender: ->
    
    #$(@el).append(@template())
    #@appendDiscoverItems(@collection)
    #this



  appendDiscoverItems: (collection) ->
    #rowLine = "<div class='discover_bookmarks_list'></div>"
    #@$('.discover_bookmarks_bottom').append rowLine
    collection.forEach ((bookmark)->
      bookmarkItemView = new Mywebroom.Views.DiscoverBookmarkGridItemView(model:bookmark)
      @$('.discover_bookmarks_list').append(bookmarkItemView.el)
      bookmarkItemView.render()
      ),this
  appendDiscoverItemsOld: (collection) ->

    # Divide collection into rows of 5.
    # Insert ul element.
    # For each in 5ple, append a grid item view.

    k = 0
    columnNum = 5
    rowArray = []

    #console.log("collection.models.length: "+collection.models.length)

    while k < collection.models.length

      i = 0
      while i < columnNum

        rowArray.push collection.at k  if k < collection.models.length
        k += 1
        i++

      # Make into ul
      rowNum = k / columnNum
      rowLine = "<ul id='discover_bookmarks_row_item_" + rowNum + "'></ul>"
      this.$('.discover_bookmarks_bottom').append rowLine

      # Now do for each in rowArray, new GridItem view and append to rowView
      for bookmark in rowArray
        bookmarkItemView = new Mywebroom.Views.DiscoverBookmarkGridItemView(model: bookmark)
        this.$('#discover_bookmarks_row_item_' + rowNum).append(bookmarkItemView.el)
        bookmarkItemView.render()

      rowArray.length = 0

