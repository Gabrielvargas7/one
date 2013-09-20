class Mywebroom.Collections.IndexUserBookmarksByUserIdAndItemIdCollection extends Backbone.Collection

  url:(userId,itemId) ->
    '/users_bookmarks/json/index_user_bookmarks_by_user_id_and_item_id/'+userId+'/'+itemId+'.json'
  comparator:(bookmark)->
  	parseInt(bookmark.get('position'))