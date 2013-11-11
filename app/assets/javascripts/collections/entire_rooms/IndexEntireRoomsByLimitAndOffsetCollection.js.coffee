class Mywebroom.Collections.IndexEntireRoomsByLimitAndOffsetCollection extends Backbone.Collection
    
  initialize: (models, options) ->
    
    @limit =  options.limit
    @offset = options.offset
  
      
  url: ->
    '/bundles/json/index_bundles_by_limit_and_offset/' + @limit + '/' + @offset + '.json'
  
     
  parse: (response) ->
      
    _.map(response, (model) ->
        obj = model
        obj.type = "ENTIRE_ROOM"
        return obj
    )
