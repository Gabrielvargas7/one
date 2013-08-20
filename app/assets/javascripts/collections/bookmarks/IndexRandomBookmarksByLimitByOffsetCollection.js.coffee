class Mywebroom.Collections.IndexRandomBookmarksByLimitByOffsetCollection extends Backbone.Collection

  url:(limit,offset) ->
    '/bookmarks/json/index_random_bookmarks_by_limit_by_offset/'+limit+'/'+offset+'.json'

