#/friends/json/index_friends_suggestion_by_user_id_by_limit_by_offset/:user_id/:limit/:offset'
class Mywebroom.Collections.IndexFriendsSuggestionsByUserIdByOffsetByLimit extends Backbone.Collection
	url: (user_id,limit,offset)->
		'/friends/json/index_friends_suggestion_by_user_id_by_limit_by_offset/'+user_id+'/'+limit+'/'+offset+'.json'
	model:Mywebroom.Models.ProfileFriendSuggestions