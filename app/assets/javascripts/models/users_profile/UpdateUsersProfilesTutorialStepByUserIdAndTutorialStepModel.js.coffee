class Mywebroom.Models.UpdateUsersProfilesTutorialStepByUserIdAndTutorialStepModel extends Backbone.Model


  @user_id
  @tutorial_step
  idAttribute: "_id",
  url:->
    '/users_profiles/json/update_users_profiles_tutorial_step_by_user_id_and_tutorial_step/'+@user_id+'/'+@tutorial_step+'.json'


  parse: (response) ->
      model = response
      Mywebroom.State.set("tutorialStep",model.tutorial_step)
      console.log("tutorialStep: "+Mywebroom.State.get("tutorialStep"))
      return model

