#Collection
class Mywebroom.Collections.index_notification_by_limit_by_offset extends Backbone.Collection
	model:Mywebroom.Models.ProfileActivity
	url: (limit,offset)->
		'/notifications/json/index_notification_by_limit_by_offset/'+limit+'/'+offset+'.json'
	
