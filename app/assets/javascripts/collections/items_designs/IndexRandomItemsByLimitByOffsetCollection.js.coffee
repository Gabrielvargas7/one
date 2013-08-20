class Mywebroom.Collections.IndexRandomItemsByLimitByOffsetCollection extends Backbone.Collection

  url:(limit,offset) ->
    '/items_designs/json/index_random_items_by_limit_by_offset/'+limit+'/'+offset+'.json'


