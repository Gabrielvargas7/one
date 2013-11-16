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
        Mywebroom.Helpers.cancelChanges()


        # Turn hidden images grey
        Mywebroom.Helpers.greyHidden()


        # Hide the Save, Cancel, Remove View
        $('#xroom_store_menu_save_cancel_remove').hide()
    )





  clickRemove: (e) ->

    #console.log("click Store Remove")

    e.preventDefault()
    e.stopPropagation()

    self = this

    bootbox.confirm("Are you sure you want to remove this object?", (result) ->
      if result

        self.removeObject()


        ###
        GREY HIDDE
        ###
        Mywebroom.Helpers.greyHidden()


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
        console.log("REMOVE OBJECT FAIL\n", response)



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




#  saveNewItems: ->
#
#    #console.log("***** Beginning Save of New Designs *****")
#
#
#    # Save the userId for use later
#    user_id = Mywebroom.State.get("signInUser").get("id")
#
#
#
#    ###
#    Number of new things
#    ###
#    #console.log("I see ", $("[data-design-has-changed=true]").size(), " new designs!")
#
#
#
#    ###
#    Capture all changed items
#    Note: we only need to capture those in 1 div
#    ###
#    $("#xroom_items_0 [data-design-has-changed=true]").each( ->
#
#
#      ###
#      ITEM ID
#      ###
#      item_id = $(this).attr("data-design-item-id")
#
#
#      ###
#      LOCATION ID
#      ###
#      location_id = $(this).attr("data-design-location-id")
#
#
#      ###
#      NEW DESIGN ID
#      ###
#      new_design_id = $(this).attr("data-design-id-client")
#
#
#      ###
#      CAPTURE OLD VARIABLES
#      ###
#      old_src_main =  $(this).attr("data-main-src-server")
#      old_src_hover = $(this).attr("data-hover-src-server")
#      old_design_id = $(this).attr("data-design-id-server")
#      old_hide =      $(this).attr("data-room-hide")
#
#
#
#      ###
#      UPDATE DOM PROPERTIES
#      ###
#      $("[data-design-item-id=" + item_id + "]").each( ->
#        $(this)
#        .attr("data-main-src-server",  $(this).attr("data-main-src-client"))
#        .attr("data-hover-src-server", $(this).attr("data-hover-src-client"))
#        .attr("data-design-id-server", $(this).attr("data-design-id-client"))
#        .attr("data-room-hide", "no")
#        .attr("data-design-has-changed", false)
#      )
#
#
#
#
#      ###
#      If the object had been hidden, toggle it's hide property
#      ###
#      if old_hide is "yes"
#
#
#        # Change Property in Server
#        hide = new Mywebroom.Models.HideUserItemsDesignByUserIdAndItemsDesignIdAndLocationIdModel({_id: user_id})
#        hide.user_id =        user_id
#        hide.item_design_id = old_design_id
#        hide.location_id =    location_id
#        hide.save
#          wait: true
#        ,
#          success: (model, response) ->
#            #console.log("TOGGLE DESIGN HIDE SUCCESS\n", model)
#
#          error: (model, response) ->
#            console.log("TOGGLE DESIGN HIDE FAIL\n", model)
#
#
#
#
#      ###
#      Persist the new design properties to the server
#      ###
#      model = new Mywebroom.Models.UpdateUserItemsDesignByUserIdAndItemsDesignIdAndLocationIdModel(
#        {
#          new_items_design_id: new_design_id
#          _id                : user_id
#        }
#      )
#
#      model.location_id    = location_id
#      model.item_design_id = old_design_id
#      model.user_id        = user_id
#      model.save
#        wait: true
#      ,
#        success: (model, response) ->
#          #console.log("UPDATE DESIGN ID SUCCESS\n", response)
#
#
#        error: (model, response) ->
#          console.log("UPDATE DESIGN ID FAIL\n", response)
#    )
