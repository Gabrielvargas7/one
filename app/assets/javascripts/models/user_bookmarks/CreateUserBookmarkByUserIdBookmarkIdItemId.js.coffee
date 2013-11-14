class Mywebroom.Models.CreateUserBookmarkByUserIdBookmarkIdItemId extends Backbone.Model
  
  @userId
  @bookmarkId
  @itemId
  defaults:
    position:2
  
  # url:->
  #   "/users_bookmarks/json/create_user_bookmark_by_user_id_and_bookmark_id_and_item_id/"+@userId+'/'+@bookmarkId+'/'+ @itemId+'.json'
  url:->
    "/users_bookmarks/json/create_user_bookmark_by_user_id_and_bookmark_id_and_item_id/"+this.get('userId')+'/'+this.get('bookmarkId')+'/'+this.get('itemId')+'.json'