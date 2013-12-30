#PopUp View made for User Item clicks.

#Required: itemData with urlToPopUp populated with img src.
#Options: Coordinates, className, template
class Mywebroom.Views.PopupFriendItemView extends Backbone.View
  @urlToPopup

  className: 'popup_friend_item_view'

  template: JST['rooms/PopUpFriendItemTemplate']

  events:
    'click #popup_friend_item_close':'closeView'
    'click .green_button':'closeView'
    'click #popup_item_first_click_close':'closeView'
    'click #xroom_header_profile':'closeView'

  initialize: ->

    #  Scroller visibility
    $("#xroom_scroll_left").hide()
    $("#xroom_scroll_right").hide()

    # Turn off Design Click too
    Mywebroom.Helpers.RoomMainHelper.turnOffDesignClick()
    Mywebroom.Helpers.RoomMainHelper.turnOffHover()

    @itemData = this.options.itemData
    @coordinates = this.options.coordinates
    @template = this.options.template if this.options.template
    @className = this.options.className if this.options.className

    #Update the State Model View Tracker and insure only one view is open at a time.
    if Mywebroom.State.get("friendItemPopupView")
      Mywebroom.State.get("friendItemPopupView").closeView()

    Mywebroom.State.set("friendItemPopupView",this)


  render: ->
    @$el.append(@template( itemData:@itemData.toJSON(), coordinates:@coordinates))
    this


  ###
  # Call this function after view is rendered and appended. If the popup is not in viewport,
  #   the popup's position will be adjusted to the center of the page based on 400x256 popup size. 
  ###
  detectViewportAndCenter: ->
    #A4(i) Detect if Popup view is in viewport
    rect = $('#popup_friend_item_wrap')[0].getBoundingClientRect()

    if not (rect.top >=0 and rect.left >=0) or 
    not (rect.bottom <= (window.innerHeight or document. documentElement.clientHeight)) or 
    not (rect.right <= (window.innerWidth or document. documentElement.clientWidth)) or
    $('body').css('zoom')>1 #When zoom is over 1, coordinates are not accurate and popup is off center.
      $('#popup_friend_item_wrap').css(
                                       "position":"absolute"
                                       "top":"50%"
                                       "left":"50%"
                                       "margin-left":"-200px"
                                       "margin-top":"-125px")

  closeView:->

    #Turn on Design Clicks
    Mywebroom.Helpers.RoomMainHelper.turnOnDesignClick()
    Mywebroom.Helpers.RoomMainHelper.turnOnHover()

    #  Scroller visibility
    $("#xroom_scroll_left").show()
    $("#xroom_scroll_right").show()

    #update the State view Tracker
    Mywebroom.State.set("friendItemPopupView",false) if Mywebroom.State.get("friendItemPopupView")
    #Remove this view
    this.remove()

class Mywebroom.Views.PopupExternalSiteWarningView extends Mywebroom.Views.PopupFriendItemView
  events:
    'click #popup_friend_item_close':'closeView'
    'click .green_button':'openSite'
  openSite: (event) ->
    # event.stopPropagation()
    # event.preventDefault()
    window.open(@options.externalUrl, '_blank') if @options.externalUrl
    @closeView()
