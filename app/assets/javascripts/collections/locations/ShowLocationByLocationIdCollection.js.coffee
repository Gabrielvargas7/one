class Mywebroom.Collections.ShowLocationByLocationIdCollection extends Backbone.Collection

  url:(locationId) ->
    '/locations/json/show_location_by_location_id/'+locationId+'.json'