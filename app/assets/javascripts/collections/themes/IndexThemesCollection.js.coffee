class Mywebroom.Collections.IndexThemesCollection extends Backbone.Collection

   url: '/themes/json/index_themes.json'
   parse: (response) ->
     _.map(response, (model) ->
       obj = model
       obj.type = "THEME"
       return obj
     )
