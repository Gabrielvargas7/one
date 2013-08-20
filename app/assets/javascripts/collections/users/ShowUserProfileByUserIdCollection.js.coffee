class Mywebroom.Collections.ShowUserProfileByUserIdCollection extends Backbone.Collection

  url:(userId) ->
    '/users/json/show_user_profile_by_user_id/'+userId+'.json'