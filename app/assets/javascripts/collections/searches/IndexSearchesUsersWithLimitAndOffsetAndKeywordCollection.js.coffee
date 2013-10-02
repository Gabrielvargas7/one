class Mywebroom.Collections.IndexSearchesUsersWithLimitAndOffsetAndKeywordCollection extends Backbone.Collection

  url:(limit,offset,keyword) ->
    '/searches/json/index_searches_users_with_limit_and_offset_and_keyword/'+limit+'/'+offset+'/'+keyword+'.json'

