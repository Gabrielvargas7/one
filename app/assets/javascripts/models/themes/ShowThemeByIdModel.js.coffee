class Mywebroom.Models.ShowThemeByIdModel extends Backbone.Model

  url: ->
    '/themes/json/show_theme_by_theme_id/' + @id + '.json'
    
  parse: (response) ->
    model = response
    model.type = "THEME"
    return model
