class Mywebroom.Collections.ShowBookmarkByBookmarkIdCollection extends Backbone.Collection

  url: (bookmark_id) ->
    '/bookmarks/json/show_bookmark_by_bookmark_id/' + bookmark_id + '.json'
  
  parse: (response) ->
    _.map(response, (model) ->
      obj = model
      obj.type = "BOOKMARK"
      return obj
    )
