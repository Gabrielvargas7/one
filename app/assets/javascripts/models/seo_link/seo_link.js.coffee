class Mywebroom.Models.SeoLink extends Backbone.Model
 
  initialize: ->
    
    switch @options.type
      when "ENTIRE_ROOM"
        @url = '/bundles/json/show_entire_room_seo_url_by_bundle_id/' + @id + '.json'
      when "BUNDLE"
        @url = '/bundles/json/show_bundle_seo_url_by_bundle_id/' + @id + '.json'
      when "THEME"
        @url = '/themes/json/show_theme_seo_url_by_theme_id' + @id + '.json'
      when "BOOKMARK"
        @url = '/bookmarks/json/show_bookmark_seo_url_by_bookmark_id/' + @id + '.json'
      when "DESIGN"
        @url = '/items_designs/json/show_items_design_seo_url_by_items_Design_id/' + @id + '.json'


