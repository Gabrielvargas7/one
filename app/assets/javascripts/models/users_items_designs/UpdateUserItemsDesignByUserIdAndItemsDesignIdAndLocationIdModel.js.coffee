class Mywebroom.Models.UpdateUserItemsDesignByUserIdAndItemsDesignIdAndLocationIdModel extends Backbone.Model


  @user_id
  @location_id
  @item_design_id
  idAttribute: "_id"
  defaults:{
    new_items_design_id:-1
  },
  url:->
    '/users_items_designs/json/update_user_items_design_by_user_id_and_items_design_id_and_location_id/'+@user_id+'/'+@item_design_id+'/'+@location_id+'.json'




