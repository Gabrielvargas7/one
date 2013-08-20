class Mywebroom.Collections.IndexSearchesUserNameByUserIdWithLimitAndOffsetAndKeywordCollection extends Backbone.Collection

  url:(userId,limit,offset,keyword) ->
    '/searches/json/index_searches_user_name_by_user_id_with_limit_and_offset_and_keyword/'+userId+'/'+limit+'/'+offset+'/'+keyword+'.json'



