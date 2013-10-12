class Mywebroom.Collections.IndexItemsCollection extends Backbone.Collection

  url: '/items/json/index_items.json'
  parse: (response) ->
    _.map(response, (model) ->
      obj = model
      obj.type = "ITEM"
      return obj
    )
