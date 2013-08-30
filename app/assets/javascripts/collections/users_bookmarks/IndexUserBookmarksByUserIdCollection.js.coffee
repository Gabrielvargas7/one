class Mywebroom.Collections.IndexUserBookmarksByUserIdCollection extends Backbone.Collection

  url:(userId) ->
    '/users_bookmarks/json/index_user_bookmarks_by_user_id/'+userId+'.json'

