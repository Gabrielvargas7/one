class Mywebroom.Collections.IndexItemsDesignsByItemIdCollection extends Backbone.Collection

  url:(itemId) ->
    '/items_designs/json/index_items_designs_by_item_id/'+itemId+'.json'
  parse: (response) ->
    _.map(response, (model) ->
      obj = model
      obj.type = "DESIGN"
      return obj
    )

