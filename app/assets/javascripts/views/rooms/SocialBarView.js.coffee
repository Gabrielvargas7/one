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
    
    if @model.get('image_name_selection')
      # DESIGN
      @targetUrl = Mywebroom.State.get('shopBaseUrl').itemDesign +
                   @model.get('id')
    
    else if @model.get('image_name_desc')
      # BOOKMARK
      @targetUrl = Mywebroom.State.get('shopBaseUrl').bookmark
    
    else
      # UNKNOWN
      @targetUrl = Mywebroom.State.get('shopBaseUrl').default
      
  
  
  render: ->
    
    $(@el).html(@template(targetUrl: @targetUrl))
    this
  
    
  ###
  EVENTS
  ###
  clickFBLikeItem: ->
      
    console.log("You clicked FB Like", @model)
    
    window.open(
      'https://www.facebook.com/sharer/sharer.php?u=' +
      encodeURIComponent(@targetUrl),
      'facebook-share-dialog',
      'width=626,height=436'
    )
    
    return false
  
 
  clickPinIt: (e) ->
    
    e.preventDefault()
    e.stopPropagation()
    
    url = @generatePinterestUrl()
    
    if url isnt false
      window.open(url,
        '_blank',
        'width=750,height=350,toolbar=0,location=0,directories=0,status=0'
      )
  
  
  ###
  EVENT HELPERS
  ###
  generatePinterestUrl: ->
  
    baseUrl =   '//pinterest.com/pin/create/button/?url='
    
    
    # SET TARGET URL
    if @targetUrl
      targetUrl = @targetUrl
    
    else if @model.get('product_url')
      targetUrl = @model.get('product_url')
    
    else
      targetUrl = "http://mywebroom.com"
    
    
    
    
    if @model.get('image_name_selection')
      # This is a design
      mediaUrl =    @model.get('image_name_selection').url
      description = @model.get('name') + ' - '
      signature =   ' - Found at myWebRoom.com'
    
    else if @model.get('image_name_desc')
      # This is a bookmark
      mediaUrl =    @model.get('image_name_desc').url
      description = @model.get('title') + ' - '
      signature =   ' - For my virtual room at myWebRoom.com'
    
    else
      # IDK what this is
      mediaUrl =  @model.get('image_name').url
      signature = ' - Found at myWebRoom.com'
    
    if !mediaUrl
      return false
    else
      description += @model.get('description') + signature
      results = baseUrl +
                encodeURIComponent(targetUrl) +
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
