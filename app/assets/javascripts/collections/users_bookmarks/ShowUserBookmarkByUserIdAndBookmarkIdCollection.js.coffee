class Mywebroom.Collections.ShowUserBookmarkByUserIdAndBookmarkIdCollection extends Backbone.Collection

  url:(userId,bookmarkId) ->
    '/users_bookmarks/json/show_user_bookmark_by_user_id_and_bookmark_id/'+userId+'/'+bookmarkId+'.json'


