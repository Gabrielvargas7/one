#/users_bookmarks/json/create_user_bookmark_custom_by_user_id/
#  Form Parameters:
#             :bookmark_url,
#             :bookmarks_category_id,
#             :image_name, (full path)
#             :item_id,
#             :title
#             :position
class Mywebroom.Models.CreateCustomUserBookmarkByUserId extends Backbone.Model
 @bookmark_url
 @bookmarks_category_id
 @image_name
 @item_id
 @title
 @position
 url: ->
  '/users_bookmarks/json/create_user_bookmark_custom_by_user_id/'+this.get('userId')+'.json'