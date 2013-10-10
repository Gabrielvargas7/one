class Mywebroom.Collections.IndexSearchesItemsDesignsWithItemIdAndLimitAndOffsetAndKeywordCollection extends Backbone.Collection

  url:(itemId,limit,offset,keyword) ->
    '/searches/json/index_searches_items_designs_with_item_id_and_limit_and_offset_and_keyword/'+itemId+'/'+limit+'/'+offset+'/'+keyword+'.json'
  parse: (response) ->
    _.map(response, (model) ->
      obj = model
      obj.type = "DESIGN"
      return obj
    )
