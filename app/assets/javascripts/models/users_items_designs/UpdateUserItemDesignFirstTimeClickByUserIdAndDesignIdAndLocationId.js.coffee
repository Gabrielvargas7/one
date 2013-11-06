#update_user_items_design_first_time_click_to_not_by_user_id_and_items_design_id_and_location_id/:user_id/:items_design_id/:location_id
class UpdateUserItemDesignFirstTimeClickByUserIdAndDesignIdAndLocationId extends Backbone.Model
  @userId
  @designId
  @locationId
  url:->
    "/users_items_designs/json/update_user_items_design_first_time_click_to_not_by_user_id_and_items_design_id_and_location_id/"+@userId+"/"+@designId+"/"+@locationId+".json"