class Mywebroom.Models.ShowBookmarkByIdModel extends Backbone.Model

  url: ->
    '/bookmarks/json/show_bookmark_by_bookmark_id/' + @id + '.json'
  
  parse: (response) ->
    model = response
    model.type = "BOOKMARK"
    return model
