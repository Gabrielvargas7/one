###
This view represents the div that holds the main store page and it's collapse bar.
At this point, the view for the collapse bar has already been created at attached 
to the #store_main_box_left element of this view's template.

Since that view has already been created, this view just creates the menu view,
but it also listens to clicks on the children elements of the collapse bar view.
###
class Mywebroom.Views.StoreLayoutView extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************


  #*******************
  #**** Templeate
  #*******************
  template: JST['store/StoreLayoutTemplate']

  #*******************
  #**** Events
  #*******************

  events: {
    'click #store_close_button':    'closeStorePageView'
    'click #store_collapse_button': 'collapseStorePageView'
  }

  #*******************
  #**** Initialize
  #*******************
  initialize: ->

  #*******************
  #**** Render
  #*******************
  render: ->

    # THIS VIEW
    $(@el).html(@template())
    
    
    
    # STORE MENU VIEW
    storeMenuView = new Mywebroom.Views.StoreMenuView()
    $('.store_main_box_right').html(storeMenuView.el)
    storeMenuView.render()



    this



  #*******************
  #**** Functions  - events
  #*******************

  #--------------------------
  # close store page
  #--------------------------
  closeStorePageView: (event) ->
    
    event.preventDefault()
    

    self = this
    console.log("click Store Close")
    
    
    ###
    Display a confirm dialog if there are any un-saved changes
    ###
    if $("[data-room_item_design=new]").size() > 0 or $("[data-room_theme=new]").size() > 0
      bootbox.confirm("Leaving this screen will not save your changes", (result) ->
        if result
          Mywebroom.State.get("storeMenuSaveCancelRemoveView").revert()
        
          # Hide the view with the Save, Cancel, Remove view
          $('#xroom_store_menu_save_cancel_remove').hide()
    
    
          $('#xroom_storepage').hide()
    
    
          # Now that we're hiding the store,
          # we need to hide the greyed out images
          # in the user's room
          $("[data-room-hide=yes]").hide()
      )
    else
      # Hide the view with the Save, Cancel, Remove view
      $('#xroom_store_menu_save_cancel_remove').hide()


      $('#xroom_storepage').hide()


      # Now that we're hiding the store,
      # we need to hide the greyed out images
      # in the user's room
      $("[data-room-hide=yes]").hide()
    
  
  
  
  
  #--------------------------
  # collapse store page
  #--------------------------
  collapseStorePageView: (event)->
    event.preventDefault()
    
    # Menu is open
    if $('#store_collapse_button img').hasClass('flipimg')
      
      # Capture State of Save, Cancel, Remove View
      @visible = $('#xroom_store_menu_save_cancel_remove').is(":visible")
      
      # Hide the Save, Cancel, Remove view
      $('#xroom_store_menu_save_cancel_remove').hide()
      
      # DON'T ALTER STATE OF SAVE, CANCEL, REMOVE BUTTONS
      
      $('.store_main_box_right').hide() # Hide the main box
      $('#store_main_box').css('width', '40px')
      $('#store_collapse_img').attr('src','http://res.cloudinary.com/hpdnx5ayv/image/upload/v1375811602/close-arrow_nwupj2.png')
      $('#store_collapse_button img').removeClass('flipimg') # Button returns to facing the right
    else # Menu is collapsed
      
      # Show Save, Cancel, Remove view if it was previously visible
      $('#xroom_store_menu_save_cancel_remove').show() if @visible
      
      # DON'T ALTER STATE OF SAVE, CANCEL, REMOVE BUTTONS
      
      $('.store_main_box_right').show() # Un-hide the main box
      
      # Note: this width should be the same as #store_main_box in stylesheets/rooms_store.css.scss
      $('#store_main_box').css('width', '780px')
      
      $('#store_collapse_button img').addClass('flipimg')
