class Mywebroom.Models.ShowUsersProfileTutorialStepByUserIdModel extends Backbone.Model

  url: ->
    '/users_profiles/json/show_users_profile_tutorial_step_by_user_id/'+@id+'.json'
