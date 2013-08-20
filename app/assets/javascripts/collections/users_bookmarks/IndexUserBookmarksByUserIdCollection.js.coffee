class Mywebroom.Collections.IndexUserBookmarksByUserIdCollection extends Backbone.Collection

  url:(userId) ->
    '/users_bookmarks/json/json_index_user_bookmarks_by_user_id/'+userId+'.json'

