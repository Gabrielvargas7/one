class Mywebroom.Models.UpdateUserThemeByUserIdAndSectionIdModel extends Backbone.Model


  @user_id
  @section_id
  idAttribute: "_id"
  defaults:{
    new_theme_id:-1
  },
  url:->
    '/users_themes/json/update_user_theme_by_user_id_and_section_id/'+@user_id+'/'+@section_id+'.json'






