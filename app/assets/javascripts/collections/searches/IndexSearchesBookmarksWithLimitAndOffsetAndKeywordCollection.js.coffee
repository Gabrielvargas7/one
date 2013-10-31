class Mywebroom.Collections.IndexSearchesBookmarksWithLimitAndOffsetAndKeywordCollection extends Backbone.Collection

  url: (limit, offset, keyword) ->
    '/searches/json/index_searches_bookmarks_with_limit_and_offset_and_keyword/' + limit + '/' + offset + '/' + keyword + '.json'

  parse: (response) ->
    _.map(response, (model) ->
      obj = model
      obj.type = "BOOKMARK"
      return obj
    )
