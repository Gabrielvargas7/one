class Mywebroom.Collections.IndexSearchesThemesWithLimitAndOffsetAndKeywordCollection extends Backbone.Collection

  url:(limit,offset,keyword) ->
    '/searches/json/index_searches_themes_with_limit_and_offset_and_keyword/'+limit+'/'+offset+'/'+keyword+'.json'
