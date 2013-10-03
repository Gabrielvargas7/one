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

  events:
    'click #store_close_button'   : 'closeStorePageView'
    'click #store_collapse_button': 'collapseStorePageView'

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

    
    @createStoreMenuView(@model)

    @



  #*******************
  #**** Functions  - events
  #*******************

  #--------------------------
  # close store page
  #--------------------------
  closeStorePageView: (event) ->
    event.preventDefault()
    console.log('add all the event to the header')


    # Hide the view with the Save, Cancel, Remove view
    $('#xroom_store_menu_save_cancel_remove').hide()
    
    
    $('#xroom_storepage').hide()


  #--------------------------
  # collapse store page
  #--------------------------
  collapseStorePageView: (event)->
    event.preventDefault()
    
    # Menu is open
    if $('#store_collapse_button img').hasClass('flipimg')
      
      # Hide the Save, Cancel, Remove view
      $('#xroom_store_menu_save_cancel_remove').hide()
      
      # DON'T ALTER STATE OF SAVE, CANCEL, REMOVE BUTTONS
      
      $('.store_main_box_right').hide() # Hide the main box
      $('#store_main_box').css('width', '40px')
      $('#store_collapse_img').attr('src','http://res.cloudinary.com/hpdnx5ayv/image/upload/v1375811602/close-arrow_nwupj2.png')
      $('#store_collapse_button img').removeClass('flipimg') # Button returns to facing the right
    else # Menu is collapsed
      
      # Show the Save, Cancel, Remove view
      $('#xroom_store_menu_save_cancel_remove').show()
      
      # DON'T ALTER STATE OF SAVE, CANCEL, REMOVE BUTTONS
      
      $('.store_main_box_right').show() # Un-hide the main box
      
      # Note: this width should be the same as #store_main_box in stylesheets/rooms_store.css.scss
      $('#store_main_box').css('width', '780px') 
      
      $('#store_collapse_button img').addClass('flipimg') 
    
    

  #*******************
  #**** Functions  -  Store Menu
  #*******************
  
  #--------------------------
  # create store menu for Theme, items, bundles
  #--------------------------
  createStoreMenuView:(model) ->
    storeMenuView = new Mywebroom.Views.StoreMenuView({model:model})
    $('.store_main_box_right').html(storeMenuView.el)
    storeMenuView.render()




