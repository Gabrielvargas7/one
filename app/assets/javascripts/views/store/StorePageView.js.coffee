class Mywebroom.Views.StorePageView extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************


  #*******************
  #**** Templeate
  #*******************
  template: JST['store/StorePageTemplate']

  #*******************
  #**** Events
  #*******************

  events:{
    'click #store_close_button':'closeStorePageView'
    'click #store_collapse_button':'collapseStorePageView'


  }

  #*******************
  #**** Initialize
  #*******************
  initialize: ->

  #*******************
  #**** Render
  #*******************
  render: ->
    console.log("storepage view: ")
    console.log(@model)
    $(@el).html(@template())

    #this.showStoreMenuSaveCancelRemoveView()
    this.createStoreMenuView(@model)

    this



  #*******************
  #**** Functions  - events
  #*******************

  #--------------------------
  # close store page
  #--------------------------
  closeStorePageView: (event) ->
    event.preventDefault()
    console.log('add all the event to the header')
#    this.options.roomHeaderView.delegateEvents() # add all header events

    this.hideStoreMenuSaveCancelRemoveView()
    $('#xroom_storepage').hide()

#    console.log('delete storePageView ')
#    this.model.destroy() # Unbind reference to the model
#    this.unbind()        # Unbind all local event bindings
#    this.remove()        # Remove view from DOM
#    delete this.$el      # Delete the jQuery wrapped object variable
#    delete this.el       # Delete the variable reference to this node


  #--------------------------
  # collapse store page
  #--------------------------
  collapseStorePageView: (event)->
    event.preventDefault()
    
    # Menu is open
    if $('#store_collapse_button img').hasClass('flipimg')
      $('.store_main_box_right').hide() # Hide the main box
      $('#store_main_box').css('width', '40px')
      $('#store_collapse_img').attr('src','http://res.cloudinary.com/hpdnx5ayv/image/upload/v1375811602/close-arrow_nwupj2.png')
      $('#store_collapse_button img').removeClass('flipimg') # Button returns to facing the right
    else # Menu is collapsed
      $('.store_main_box_right').show() # Un-hide the main box
      $('#store_main_box').css('width', '700px') 
      $('#store_collapse_button img').addClass('flipimg') 
    
    

  #*******************
  #**** Functions  -  Store Menu
  #*******************

  #--------------------------
  # show store menu for save cancel and remove
  #--------------------------
  showStoreMenuSaveCancelRemoveView: ->
    $('#xroom_store_menu_save_cancel_remove').show()

  #--------------------------
  # hide store menu for save cancel and remove
  #--------------------------
  hideStoreMenuSaveCancelRemoveView: ->
    $('#xroom_store_menu_save_cancel_remove').hide()

  #--------------------------
  # create store menu for Theme, items, bundles
  #--------------------------
  createStoreMenuView:(model) ->
    storeMenuView = new Mywebroom.Views.StoreMenuView({model:model})
#    $('.store_main_box_right').append(storeMenuView.el)
    $('.store_main_box_right').html(storeMenuView.el)
    storeMenuView.render()




