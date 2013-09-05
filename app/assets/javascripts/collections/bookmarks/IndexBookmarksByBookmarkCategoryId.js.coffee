class Mywebroom.Collections.IndexBookmarksByBookmarksCategoryId extends Backbone.Collection
	url:(categoryId) ->
		"/bookmarks/json/index_bookmarks_by_bookmarks_category_id/"+categoryId+".json"