class Mywebroom.Collections.ShowUserThemeByUserIdAndSectionIdCollection extends Backbone.Collection

  url:(userId,sectionId) ->
    '/users_themes/json/show_user_theme_by_user_id_and_section_id/'+userId+'/'+sectionId+'.json'

