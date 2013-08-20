class Mywebroom.Collections.IndexUserItemsDesignsByUserIdCollection extends Backbone.Collection

  url:(userId) ->
    '/users_items_designs/json/index_user_items_designs_by_user_id/'+userId+'.json'
