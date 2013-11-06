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

