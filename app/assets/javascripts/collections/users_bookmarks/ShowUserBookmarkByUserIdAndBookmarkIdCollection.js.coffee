class Mywebroom.Collections.ShowUserBookmarkByUserIdAndBookmarkIdCollection extends Backbone.Collection

  initialize: (model, options) ->

    @user_id = options.user_id
    @bookmark_id = options.bookmark_id


  url: ->
    
    '/users_bookmarks/json/show_user_bookmark_by_user_id_and_bookmark_id/' + @user_id + '/' + @bookmark_id + '.json'
