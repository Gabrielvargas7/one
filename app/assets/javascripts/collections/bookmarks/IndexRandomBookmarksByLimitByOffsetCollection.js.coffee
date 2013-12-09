class Mywebroom.Collections.IndexRandomBookmarksByLimitByOffsetCollection extends Backbone.Collection


  initialize: (models, options) ->

    @limit =  options.limit
    @offset = options.offset


  url: ->
    '/bookmarks/json/index_random_bookmarks_by_limit_by_offset/' + @limit + '/' + @offset + '.json'


  parse: (response) ->

    _.map(response, (model) ->
      obj = model
      obj.type = "BOOKMARK"
      return obj
    )
