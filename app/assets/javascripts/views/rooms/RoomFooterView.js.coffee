class Mywebroom.Views.RoomFooterView extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************

  #*******************
  #**** Templeate
  #*******************

  template: JST['rooms/RoomFooterTemplate']



  #*******************
  #**** Events
  #*******************

  events:{

    'click #footer_about_us'   :'footerAbout'
    'click #footer_help'   : 'footerHelp'
    'click #footer_shop'   : 'footerShop'
    'click #footer_blog'   : 'footerBlog'

  }


  #*******************
  #**** Initialize
  #*******************

  initialize: ->


    #*******************
    #**** Render
    #*******************
  render: ->
    #console.log("Adding the RoomFooterView with model:")
    $(@el).append(@template())
    this


  #--------------------------
  #  *** function logout
  #--------------------------
  footerAbout: (event) ->

    event.preventDefault()

    origin =  window.location.origin
    origin += "/about"

    window.location.replace(origin)

  footerHelp: (event) ->

    event.preventDefault()

    origin =  window.location.origin
    origin += "/help"

    window.location.replace(origin)

  footerShop: (event) ->
    event.preventDefault()

    origin =  window.location.origin
    origin += "/shop"

    window.location.replace(origin)

  footerBlog: (event) ->
    event.preventDefault()

    origin = "http://blog.mywebroom.com"

    window.location.replace(origin)
