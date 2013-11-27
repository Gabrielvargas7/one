# users_bookmarks/json_index_user_bookmarks_by_user_id_by_limit_and_offset/:user_id/:limit/:offset
class Mywebroom.Collections.IndexUserBookmarksByUserIdByLimitAndOffset extends Backbone.Collection
  @userId
  @limit
  @offset
  url:(userId,limit,offset)->
    "/users_bookmarks/json/index_user_bookmarks_by_user_id_by_limit_and_offset/"+userId+"/"+limit+"/"+offset+".json"
  
  parse: (response) ->
    _.map(response, (model) ->
      obj = model
      obj.type = "BOOKMARK"
      return obj
    )