class Mywebroom.Collections.IndexBookmarksByBookmarksCategoryId extends Backbone.Collection

  initialize: (models, options) ->

    @categoryId = options.categoryId


  url: ->
    "/bookmarks/json/index_bookmarks_by_bookmarks_category_id/" + @categoryId + ".json"



  parse: (response) ->

    _.map(response, (model) ->
      obj = model
      obj.type = "BOOKMARK"
      return obj
    )
