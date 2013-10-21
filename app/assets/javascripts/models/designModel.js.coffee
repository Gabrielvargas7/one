class Mywebroom.Models.DesignModel extends Backbone.Model

  url: ->
    '/items_designs/json/show_item_design_by_id/' + @id + '.json'
    
  parse: (response) ->
    model = response
    model.type = "DESIGN"
    return model
