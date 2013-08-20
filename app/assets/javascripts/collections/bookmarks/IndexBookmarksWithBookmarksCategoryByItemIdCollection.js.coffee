class Mywebroom.Collections.IndexBookmarksWithBookmarksCategoryByItemIdCollection extends Backbone.Collection

  url: (itemId)->
     '/bookmarks/json/index_bookmarks_with_bookmarks_category_by_item_id/'+itemId+'.json'




