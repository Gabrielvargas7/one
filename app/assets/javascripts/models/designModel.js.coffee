class Mywebroom.Models.DesignModel extends Backbone.Model

  url: ->
    '/items_designs/' + @id + '.json'
    
  parse: (response) ->
    model = response
    model.type = "DESIGN"
    return model
