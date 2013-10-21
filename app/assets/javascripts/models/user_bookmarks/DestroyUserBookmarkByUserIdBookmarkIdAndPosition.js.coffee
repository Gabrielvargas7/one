#Used to Delete a user bookmark. Just set the url to delete. Then call destroyUserBookmark. 
class Mywebroom.Models.DestroyUserBookmarkByUserIdBookmarkIdAndPosition extends Backbone.Model
  @userId
  @bookmarkId
  @position
  url:(userId,bookmarkId,position)->
    '/users_bookmarks/json/destroy_user_bookmark_by_user_id_and_by_bookmark_id_and_position/'+userId+'/'+bookmarkId+'/'+position+'.json'
  destroyUserBookmark:->
    jQuery.ajax
      'url':this.get('url')
      'type':'DELETE'