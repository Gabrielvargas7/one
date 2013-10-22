class Mywebroom.Collections.IndexItemsDesignsOfBundleByBundleIdCollection extends Backbone.Collection

  url:(bundleId) ->
    '/items_designs/json/index_items_designs_of_bundle_by_bundle_id/'+bundleId+'.json'
  
  parse: (response) ->
    _.map(response, (model) ->
      obj = model
      obj.type = "DESIGN"
      return obj
    )

