class Mywebroom.Collections.IndexTutorialsByLimitAndOffsetCollection extends Backbone.Collection

  url: (limit, offset) ->
    'tutorials/json/index_tutorials_by_limit_and_offset/' + limit + '/' + offset + '.json'



