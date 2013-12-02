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
    'click .fb_like_item':     'clickFBLikeItem'
    'click .pinterest_item':   'clickPinIt'
    'click .info_button_item': 'clickInfo'
  }




  render: ->

    $(@el).html(@template())
    this


  ###
  EVENTS
  ###
  clickFBLikeItem: ->

    #console.log("You clicked FB Like", @model)
    url = Mywebroom.Helpers.getSEOLink(@model.get('id'), @model.get('type'))


    window.open(
      'https://www.facebook.com/sharer/sharer.php?u=' +
      encodeURIComponent(url.get("seo_url")),
      'facebook-share-dialog',
      'width=626,height=436'
    )

    return false




  clickPinIt: (event) ->

    event.preventDefault()
    event.stopPropagation()


    url = @generatePinterestUrl()

    window.open(url,
      '_blank',
      'width=750,height=350,toolbar=0,location=0,directories=0,status=0'
    )



  clickInfo: (event) ->

    event.preventDefault()
    event.stopPropagation()

    url = Mywebroom.Helpers.getSEOLink(@model.get('id'), @model.get('type'))


    window.open(url.get("seo_url"), '_blank')



  ###
  EVENT HELPERS
  ###
  generatePinterestUrl: ->


    if not @model.has('id')
      console.error('model without id', @model)


    if not @model.has('type')
      console.error('model without type', @model)



    type = @model.get('type')
    url = Mywebroom.Helpers.getSEOLink(@model.get('id'), type)


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
        signature = ' - Check out this virtual room at myWebRoom.com'

      when "BUNDLE"
        mediaUrl = @model.get('image_name')
        description = @model.get('name')
        signature = ' - For my virtual room at myWebRoom.com'

      when "THEME"
        mediaUrl = @model.get('image_name_selection')
        description = @model.get('name')
        signature = ' - For my virtual room at myWebRoom.com'



    description += @model.get('description') + signature
    results = baseUrl +
              encodeURIComponent(url.get("seo_url")) +
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
