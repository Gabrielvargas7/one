class Mywebroom.Models.UpdateUsersProfilesTutorialStepByUserIdAndTutorialStepModel extends Backbone.Model


  @user_id
  @tutorial_step
  idAttribute: "_id",
  url:->
    '/users_profiles/json/update_users_profiles_tutorial_step_by_user_id_and_tutorial_step/'+@user_id+'/'+@tutorial_step+'.json'


