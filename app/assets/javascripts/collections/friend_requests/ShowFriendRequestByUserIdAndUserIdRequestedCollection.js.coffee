class Mywebroom.Collections.ShowFriendRequestByUserIdAndUserIdRequestedCollection extends Backbone.Collection

  initialize: (models, options) ->

    @userId =          options.userId
    @userIdRequested = options.userIdRequested


  url: (userId, userIdRequested) ->

    '/friend_requests/json/show_friend_request_by_user_id_user_id_requested/' + @userId + '/' + @userIdRequested + '.json'
