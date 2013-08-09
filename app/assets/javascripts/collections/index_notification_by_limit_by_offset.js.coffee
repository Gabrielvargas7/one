#Collection
class Mywebroom.Collections.index_notification_by_limit_by_offset extends Backbone.Model
	model:Mywebroom.Models.ProfileActivity
	limit:6
	offset:0
	url: ()->
		'/notifications/json/index_notification_by_limit_by_offset/'+@limit+'/'+@offset+'.json'
	
