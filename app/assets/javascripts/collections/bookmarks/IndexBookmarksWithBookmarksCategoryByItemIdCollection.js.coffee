class Mywebroom.Collections.IndexBookmarksWithBookmarksCategoryByItemIdCollection extends Backbone.Collection

  initialize: (models, options) ->

    @itemId = options.itemId


  url: ->
    '/bookmarks/json/index_bookmarks_with_bookmarks_category_by_item_id/' + @itemId + '.json'


  parse: (response) ->

    _.map(response, (model) ->
      obj = model
      obj.type = "BOOKMARK"
      obj
    )
