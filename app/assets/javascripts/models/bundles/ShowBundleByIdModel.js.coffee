class Mywebroom.Models.ShowBundleByIdModel extends Backbone.Model

  url: ->
    '/bundles/json/show_bundle_by_id/' + @id + '.json'
    
  parse: (response) ->
    model = response
    model.type = "BUNDLE"
    return model
