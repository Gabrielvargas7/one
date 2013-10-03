class Mywebroom.Models.HideUserItemsDesignByUserIdAndItemsDesignIdAndLocationIdModel extends Backbone.Model    
  
  @user_id
  @item_design_id
  @location_id
  
  idAttribute: "_id"
  
  url:->
    '/users_items_designs/json/update_hide_user_items_design_by_user_id_and_items_design_id_and_location_id/' + @user_id + '/' + @item_design_id + '/' + @location_id + '.json'
