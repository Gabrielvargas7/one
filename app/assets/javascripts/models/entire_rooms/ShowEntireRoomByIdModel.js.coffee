class Mywebroom.Models.ShowEntireRoomByIdModel extends Backbone.Model

  url: ->
    '/bundles/json/show_bundle_by_id/' + @id + '.json'
    
  parse: (response) ->
    model = response
    model.type = "ENTIRE_ROOM"
    return model
