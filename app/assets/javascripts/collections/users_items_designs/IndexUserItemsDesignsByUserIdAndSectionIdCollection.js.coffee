class Mywebroom.Collections.IndexUserItemsDesignsByUserIdAndSectionIdCollection extends Backbone.Collection

  url: (userId, sectionId) ->
    '/users_items_designs/json/index_user_items_designs_by_user_id_and_section_id/' + userId + '/' + sectionId + '.json'


  parse: (response) ->
    _.map(response, (model) ->
      obj = model
      obj.type = "BOOKMARK"
      return obj
    )
