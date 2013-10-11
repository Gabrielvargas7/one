class Mywebroom.Collections.IndexSearchesBookmarksWithLimitAndOffsetAndKeywordCollection extends Backbone.Collection

  url:(limit,offset,keyword) ->
    '/searches/json/index_searches_bookmarks_with_limit_and_offset_and_keyword/'+limit+'/'+offset+'/'+keyword+'.json'

