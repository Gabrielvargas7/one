class Mywebroom.Collections.IndexSearchesThemesWithLimitAndOffsetAndKeywordCollection extends Backbone.Collection

  url:(limit,offset,keyword) ->
    '/searches/json/index_searches_themes_with_limit_and_offset_and_keyword/'+limit+'/'+offset+'/'+keyword+'.json'
  parse: (response) ->
    _.map(response, (model) ->
      obj = model
      obj.type = "THEME"
      return obj
    )
