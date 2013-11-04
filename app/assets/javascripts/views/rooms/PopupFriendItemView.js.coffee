class Mywebroom.Views.PopupFriendItemView extends Backbone.View
  @urlToPopup
  
  className: 'popup_friend_item_view'

  template: JST['rooms/PopUpFriendItemTemplate']

  events:
    'click #popup_friend_item_close':'closeView'
    'click .popup_friend_green_button':'closeView'

  initialize: ->
    
    #  Scroller visibility
    $("#xroom_scroll_left").hide()
    $("#xroom_scroll_right").hide()

    @itemData = this.options.itemData
    @coordinates = this.options.coordinates
    @urlToPopup = Mywebroom.Data.FriendItemPopupUrls[ @itemData.get('id') ] if @itemData
    # @itemData.set('y', @itemData.get('y') - 255)
  
  render: ->
    @$el.append(@template( urlToPopup:@urlToPopup, itemData:@itemData.toJSON(), coordinates:@coordinates))
    this

  closeView:->
    #Turn on Item Clicks
    Mywebroom.Helpers.turnOnDesignClick() 
    #  Scroller visibility
    $("#xroom_scroll_left").show()
    $("#xroom_scroll_right").show()
    #Remove this view
    this.remove()

