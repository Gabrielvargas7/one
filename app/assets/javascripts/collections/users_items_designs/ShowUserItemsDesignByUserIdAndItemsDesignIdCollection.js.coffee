class Mywebroom.Collections.ShowUserItemsDesignByUserIdAndItemsDesignIdCollection extends Backbone.Collection

  url:(userId,itemsDesignId) ->
    '/users_items_designs/json/show_user_items_design_by_user_id_and_items_design_id/'+userId+'/'+itemsDesignId+'.json'


