class Mywebroom.Models.ShowSeoLinkByIdModel extends Backbone.Model

  url: ->
    
    type = this.get("type")
    
    switch type
      when "ENTIRE_ROOM"
        return '/bundles/json/show_entire_room_seo_url_by_bundle_id/' + @id + '.json'
      when "BUNDLE"
        return '/bundles/json/show_bundle_seo_url_by_bundle_id/' + @id + '.json'
      when "THEME"
        return '/themes/json/show_theme_seo_url_by_theme_id' + @id + '.json'
      when "BOOKMARK"
        return '/bookmarks/json/show_bookmark_seo_url_by_bookmark_id/' + @id + '.json'
      when "DESIGN"
        return '/items_designs/json/show_items_design_seo_url_by_items_design_id/' + @id + '.json'
