class Mywebroom.Views.PopupFriendItemView extends Backbone.View
  @urlToPopup
  
  className: 'popup_friend_item_view'

  template: JST['rooms/PopUpFriendItemTemplate']

  events:
    'click #popup_friend_item_close':'closeView'
    'click .green_button':'closeView'
    'click #popup_item_first_click_close':'closeView'

  initialize: ->
    
    #  Scroller visibility
    $("#xroom_scroll_left").hide()
    $("#xroom_scroll_right").hide()
    # Turn off Design Click too
    # Probably disable header buttons too
    @itemData = this.options.itemData
    @coordinates = this.options.coordinates
    @template = this.options.template if this.options.template
    @className = this.options.className if this.options.className
 
    # @itemData.set('y', @itemData.get('y') - 255)
  
  render: ->
    @$el.append(@template( itemData:@itemData.toJSON(), coordinates:@coordinates))
    this

  closeView:->
    #Turn on Item Clicks
    Mywebroom.Helpers.turnOnDesignClick() 
    #  Scroller visibility
    $("#xroom_scroll_left").show()
    $("#xroom_scroll_right").show()
    #Remove this view
    this.remove()

