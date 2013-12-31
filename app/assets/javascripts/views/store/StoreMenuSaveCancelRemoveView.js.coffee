###
View that displays the SAVE, CANCEL, REMOVE buttons
###
class Mywebroom.Views.StoreMenuSaveCancelRemoveView extends Backbone.View


  #*******************
  #**** Template
  #*******************
  template: JST['store/StoreMenuSaveCancelRemoveTemplate']


  #*******************
  #**** Events
  #*******************
  events: {
    'click #xroom_store_save'  : 'clickSave'
    'click #xroom_store_cancel': 'clickCancel'
    'click #xroom_store_remove': 'clickRemove'
  }


  #*******************
  #**** Render
  #*******************
  render: ->
    $(@el).append(@template())
    this




  #*******************
  #**** Events
  #*******************
  clickSave: (e) ->

    #console.log("save clicked")

    e.preventDefault()
    e.stopPropagation()



    # Displays save message
    toastr.options = {
      "closeButton":     false
      "debug":           false
      "positionClass":   "toast-bottom-left"
      "onclick":         null
      "showDuration":    "300"
      "hideDuration":    "1000"
      "timeOut":         "2000"
      "extendedTimeOut": "1000"
      "showEasing":      "swing"
      "hideEasing":      "linear"
      "showMethod":      "fadeIn"
      "hideMethod":      "fadeOut"
    }

    # Display the Toastr message
    toastr.success("The changes to your room have been saved.")

    # Tweak the Toastr message so it display where we want it to
    $('.toast-bottom-left').css({'bottom':'76%', 'left':'7%'})





    # Hide the Save, Cancel, Remove View
    $('#xroom_store_menu_save_cancel_remove').hide()







    # Save Theme
    @saveNewTheme()

    # Save Designs
#    @saveNewItems()
    Mywebroom.Helpers.StoreSaveCancelRemoveHelper.saveNewItems()






  clickCancel: (e) ->

    #console.log("click Store Cancel")

    e.preventDefault()
    e.stopPropagation()

    self = this


    bootbox.confirm("Are you sure you want to cancel all the changes you made in your room?", (result) ->
      if result

        # Change All DOM properties back to their original
        Mywebroom.Helpers.RoomMainHelper.cancelChanges()


        # Turn hidden images gray
        Mywebroom.Helpers.RoomMainHelper.grayHidden()


        # Hide the Save, Cancel, Remove View
        $('#xroom_store_menu_save_cancel_remove').hide()
    )





  clickRemove: (e) ->

    #console.log("click Store Remove")

    e.preventDefault()
    e.stopPropagation()

    self = this

    bootbox.confirm("<h4>Are you sure you want to remove this object?</h4><br><p>Don't worry, you can add the object back to your room later and your bookmarks in this object will still be here!</p>", (result) ->
      if result

        self.removeObject()


        ###
        GRAY HIDDE
        ###
        Mywebroom.Helpers.RoomMainHelper.grayHidden()


        # Hide the Save, Cancel, Remove View
        $('#xroom_store_menu_save_cancel_remove').hide()

    )






  removeObject: ->

    userId = Mywebroom.State.get("signInUser").get("id")


    # Persist to server
    hide = new Mywebroom.Models.HideUserItemsDesignByUserIdAndItemsDesignIdAndLocationIdModel({_id: userId})
    hide.user_id          = userId
    hide.item_design_id   = Mywebroom.State.get("$activeDesign").attr("data-design-id-server")
    hide.location_id      = Mywebroom.State.get("$activeDesign").attr("data-design-location-id")
    hide.save
      wait: true
    ,
      success: (model, response) ->
        #console.log("REMOVE OBJECT SUCCESS\n", response)

      error: (model, response) ->
        console.error("REMOVE OBJECT FAIL\n", response)



    ###
    UPDATE DOM
    ###
    Mywebroom.State.get("$activeDesign")
    .attr("data-room-hide", "yes")
    .attr("data-room-highlighted", false)
    .attr("data-design-has-changed", false)




  #*******************
  #**** Save
  #*******************
  saveNewTheme: ->

    #console.log("***** Beginning Save of New Theme *****")


    # Check to see if the theme is new
    if $(".current_background").attr("data-theme-has-changed") is "true" # <-- NOTE: string here

      ###
      USER ID
      ###
      user_id = Mywebroom.State.get("signInUser").get("id")


      ###
      NEW THEME ID
      ###
      new_theme_id = $(".current_background").attr("data-theme-id-client")


      ###
      SECTION ID
      ###
      section_id = $(".current_background").attr("data-section-id")




      # UPDATE PROPERTIES IN DOM
      $(".current_background")
      .attr("data-theme-src-server", $(".current_background").attr("data-theme-src-client"))
      .attr("data-theme-id-server",  $(".current_background").attr("data-theme-id-client"))
      .attr("data-theme-has-changed", false)




      # Persist new theme to server
      updateTheme = new Mywebroom.Models.UpdateUserThemeByUserIdAndSectionIdModel({new_theme_id: new_theme_id, _id: user_id})
      updateTheme.section_id = section_id
      updateTheme.user_id =    user_id
      updateTheme.save
        wait: true
      ,
        success: (model, response) ->
          #console.log("THEME SAVE SUCCESS\n", response)

        error: (model, response) ->
          console.error("THEME SAVE FAIL\n", response)
