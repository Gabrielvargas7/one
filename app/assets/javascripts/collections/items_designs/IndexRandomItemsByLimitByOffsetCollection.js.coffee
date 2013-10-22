class Mywebroom.Collections.IndexRandomItemsByLimitByOffsetCollection extends Backbone.Collection

  url: (limit, offset) ->
    '/items_designs/json/index_random_items_by_limit_by_offset/' + limit + '/' + offset + '.json'

  parse: (response) ->
    _.map(response, (model) ->
      obj = model
      obj.type = "DESIGN"
      return obj
    )
