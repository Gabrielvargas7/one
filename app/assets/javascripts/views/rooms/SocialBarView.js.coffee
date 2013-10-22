###
This view represents the div that pops up over a design
or bookmark with the FaceBook, Pinterest and Info buttons.

The Info URL is set by fetching the shopBaseUrl object from
the state model and inspecting it's properties.

The urls of this object are simply hard-coded.
###
class Mywebroom.Views.SocialBarView extends Backbone.View
  
  ###
  CLASS
  ###
  className: 'social_bar'
  
  
  ###
  TEMPLATE
  ###
  template: JST['profile/SocialBarTemplate']
  
  
  ###
  EVENTS
  ###
  events: {
    'click .fb_like_item':   'clickFBLikeItem'
    'click .pinterest_item': 'clickPinIt'
  }
  
  
  initialize: ->
    
    id =   @model.get('id')
    type = @model.get('type')
    
    
    @seoLinkModel = Mywebroom.Helpers.getSEOLink(id, type)
  
    
    
  
  render: ->
    
    $(@el).html(@template(targetUrl: @seoLinkModel.get("seo_url")))
    this
  
    
  ###
  EVENTS
  ###
  clickFBLikeItem: ->
      
    #console.log("You clicked FB Like", @model)
    
    window.open(
      'https://www.facebook.com/sharer/sharer.php?u=' +
      encodeURIComponent(@seoLinkModel.get("seo_url")),
      'facebook-share-dialog',
      'width=626,height=436'
    )
    
    return false
  
 
  clickPinIt: (e) ->
    
    e.preventDefault()
    e.stopPropagation()
    
    
    url = @generatePinterestUrl()
    
    window.open(url,
      '_blank',
      'width=750,height=350,toolbar=0,location=0,directories=0,status=0'
    )
  
  
  ###
  EVENT HELPERS
  ###
  generatePinterestUrl: ->
  
    type = @seoLinkModel.get('type')
    baseUrl = '//pinterest.com/pin/create/button/?url='
    
    
    switch type
      
      when "DESIGN"
        mediaUrl =    @model.get('image_name_selection').url
        description = @model.get('name') + ' - '
        signature =   ' - Found at myWebRoom.com'
        
      when "BOOKMARK"
        mediaUrl =    @model.get('image_name_desc').url
        description = @model.get('title') + ' - '
        signature =   ' - For my virtual room at myWebRoom.com'
      
      when "ENTIRE_ROOM"
        mediaUrl = @model.get('image_name_set').url
        description = @model.get('name')
        signature = ' - Entire Room'
      
      when "BUNDLE"
        mediaUrl = @model.get('image_name')
        description = @model.get('name')
        signature = ' - Bundle'
        
      when "THEME"
        mediaUrl = @model.get('image_name_selection')
        description = @model.get('name')
        signature = ' - Theme'
      
     
  
    description += @model.get('description') + signature
    results = baseUrl +
              encodeURIComponent(@seoLinkModel.get("seo_url")) +
              '&media=' +
              encodeURIComponent(mediaUrl) +
              '&description=' +
              encodeURIComponent(description)
    
    return results


  ###
  METHODS
  ###
  hide: ->
  
    $(@el).hide()
  

  show: ->
  
    $(@el).show()
