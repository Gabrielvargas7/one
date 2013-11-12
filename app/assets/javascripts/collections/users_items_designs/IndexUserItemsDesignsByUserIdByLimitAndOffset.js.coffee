#/users_items_designs/json/index_user_items_designs_by_user_id_by_limit_and_offset/28/10/0.json
class Mywebroom.Collections.IndexUserItemsDesignsByUserIdByLimitAndOffset extends Backbone.Collection
  @userId
  @limit
  @offset

  url:(userId,limit,offset)->
    "/users_items_designs/json/index_user_items_designs_by_user_id_by_limit_and_offset/"+userId+"/"+limit+"/"+offset+".json"