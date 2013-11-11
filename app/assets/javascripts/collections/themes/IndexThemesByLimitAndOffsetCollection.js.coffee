class Mywebroom.Collections.IndexThemesByLimitAndOffsetCollection extends Backbone.Collection
    
  initialize: (models, options) ->
    
    @limit =  options.limit
    @offset = options.offset
  
      
  url: ->
    '/themes/json/index_themes_by_limit_and_offset/' + @limit + '/' + @offset + '.json'
  
     
  parse: (response) ->
      
    _.map(response, (model) ->
        obj = model
        obj.type = "THEME"
        return obj
    )
