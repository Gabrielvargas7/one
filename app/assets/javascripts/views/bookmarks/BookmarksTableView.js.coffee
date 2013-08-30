class Mywebroom.Views.MyBookmarksWrap extends Backbone.View
	#my_bookmarks_list_wrap.
	#template includes bookmarks_top
	#append bookmark_bottom
class Mywebroom.Views.BookmarksGridTableWrap extends Backbone.View
	#my_bookmarks_bottom div wrapper
	#append table
class Mywebroom.Views.MyBookmarksTable extends Backbone.View
	#el: table
	#for every 5 items in collection, append tr
class Mywebroom.Views.MyBookmarksTableRow extends Backbone.View
	#el:tr 
	#for each item in collection, append td

class Mywebroom.Views.MyBookmarksGridItemView extends Backbone.View
	#el:td
	#