class Mywebroom.Collections.IndexBundlesCollection extends Backbone.Collection

  url: '/bundles/json/index_bundles.json'
  parse: (response) ->
    _.map(response, (model) ->
      obj = model
      obj.type = "BUNDLE"
      return obj
    )
