class Mywebroom.Views.RoomFirstTimePopupView extends Backbone.View


  #*******************
  #**** Template
  #*******************
  template: JST['rooms/RoomFirstTimePopupTemplate']


  #*******************
  #**** Events
  #*******************
  events: {
    'click .room_first_time_popup_close_btn':   'roomFirstTimePopupCloseBtn'
    'click #popup_item_first_click_close_x':   'roomFirstTimePopupCloseBtnX'

  }


  #*******************
  #**** Render
  #*******************
  render: ->

    # THIS VIEW
    @firstTimeClickedItem = Mywebroom.State.get("firstTimePopupItem")
    #console.log(@firstTimeClickedItem)
    $(@el).html(@template(firstTimeClickedItem:@firstTimeClickedItem))


    this




  #--------------------------
  # close store page
  #--------------------------
  roomFirstTimePopupCloseBtn: (e) ->

    e.preventDefault()
    e.stopPropagation()

    #console.log("close first time pop up")
    itemData = Mywebroom.State.get("firstTimePopupItem")
    dom_item_id = Mywebroom.State.get('dom_item_id')

    #1a. Send DB clicked item. Also, change the StateModel, so clicking again won't count as first time.
    updateClickedItemModel = new Mywebroom.Models.UpdateUserItemDesignFirstTimeClickByUserIdAndDesignIdAndLocationId({id:0})
    updateClickedItemModel.userId = Mywebroom.State.get('roomData').get('user').id
    updateClickedItemModel.designId = itemData.get('items_design_id')
    updateClickedItemModel.locationId = itemData.get('location_id')
    updateClickedItemModel.save #Makes PUT request to DB at #/users_items_designs/json/update_user_items_design_first_time_click_to_not_by_user_id_and_items_design_id_and_location_id/10000001/1000/1.json
      wait: true

    #1a.. Update State Model locally so we don't have to refetch
    Mywebroom.State.get('roomItems').findWhere({'item_id':itemData.get('item_id').toString()}).set('first_time_click',"n")

    #console.log(dom_item_id)
    #console.log(itemData)

    bookmarksView = new Mywebroom.Views.BookmarksView
      items_name: Mywebroom.Helpers.getItemNameOfItemId(parseInt(dom_item_id))
      item_id: dom_item_id
      user: Mywebroom.State.get("roomUser").get("id")


    $('#room_bookmark_item_id_container_' + dom_item_id).append(bookmarksView.el)
    bookmarksView.render()




    #console.log('Kill: ', this);
    this.unbind() # Unbind all local event bindings
    this.remove() # Remove view from DOM
    delete this.$el # Delete the jQuery wrapped object variable
    delete this.el


  roomFirstTimePopupCloseBtnX: (e) ->
    e.preventDefault()
    e.stopPropagation()

    #console.log('Kill: ', this);
    this.unbind() # Unbind all local event bindings
    this.remove() # Remove view from DOM
    delete this.$el # Delete the jQuery wrapped object variable
    delete this.el
