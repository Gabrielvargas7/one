class Mywebroom.Collections.IndexItemsDesignsByItemIdAndLimitOffsetCollection extends Backbone.Collection
    
  initialize: (models, options) ->
    
    @item_id = options.item_id
    @limit =   options.limit
    @offset =  options.offset
  
      
  url: ->
    '/items_designs/json/index_items_designs_by_item_id_and_limit_offset/' + @item_id + '/' + @limit + '/' + @offset + '.json'
  
 
  parse: (response) ->
      
    _.map(response, (model) ->
        obj = model
        obj.type = "DESIGN"
        return obj
    )
