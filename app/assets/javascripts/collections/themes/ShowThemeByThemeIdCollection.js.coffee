class Mywebroom.Collections.ShowThemeByThemeIdCollection extends Backbone.Collection

  url:(themeId) ->
    '/themes/json/show_theme_by_theme_id/'+themeId+'.json'