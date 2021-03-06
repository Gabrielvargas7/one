# /users_bookmarks/json/index_user_bookmarks_by_user_id_and_item_id_by_limit_and_offset/:user_id/:item_id/:limit/:offset
class Mywebroom.Collections.IndexUserBookmarksByUserIdAndItemIdByLimitAndOffset extends Backbone.Collection
  @userId
  @itemId
  @limit
  @offset
  url:(userId,itemId,limit,offset)->
    "/users_bookmarks/json/index_user_bookmarks_by_user_id_and_item_id_by_limit_and_offset/"+userId+"/"+itemId+"/"+limit+"/"+offset+".json"
  
  parse: (response) ->
    _.map(response, (model) ->
      obj = model
      obj.type = "BOOKMARK"
      return obj
    )  