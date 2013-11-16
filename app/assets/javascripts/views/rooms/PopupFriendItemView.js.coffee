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
    Mywebroom.Helpers.turnOffDesignClick()
    Mywebroom.Helpers.turnOffHover()

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

  closeView:->

    #Turn on Design Clicks
    Mywebroom.Helpers.turnOnDesignClick()
    Mywebroom.Helpers.turnOffHover()

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
