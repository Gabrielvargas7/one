Mywebroom.Helpers.StoreSaveCancelRemoveHelper = {


  saveNewItems: ->

    #console.log("***** Beginning Save of New Designs *****")

    # Save the userId for use later
    user_id = Mywebroom.State.get("signInUser").get("id")



    ###
    Number of new things
    ###
    #console.log("I see ", $("[data-design-has-changed=true]").size(), " new designs!")



    ###
    Capture all changed items
    Note: we only need to capture those in 1 div
    ###
    $("#xroom_items_0 [data-design-has-changed=true]").each( ->


      ###
      ITEM ID
      ###
      item_id = $(this).attr("data-design-item-id")


      ###
      LOCATION ID
      ###
      location_id = $(this).attr("data-design-location-id")


      ###
      NEW DESIGN ID
      ###
      new_design_id = $(this).attr("data-design-id-client")


      ###
      CAPTURE OLD VARIABLES
      ###
      old_src_main =  $(this).attr("data-main-src-server")
      old_src_hover = $(this).attr("data-hover-src-server")
      old_design_id = $(this).attr("data-design-id-server")
      old_hide =      $(this).attr("data-room-hide")



      ###
      UPDATE DOM PROPERTIES
      ###
      $("[data-design-item-id=" + item_id + "]").each( ->
        $(this)
        .attr("data-main-src-server",  $(this).attr("data-main-src-client"))
        .attr("data-hover-src-server", $(this).attr("data-hover-src-client"))
        .attr("data-design-id-server", $(this).attr("data-design-id-client"))
        .attr("data-room-hide", "no")
        .attr("data-design-has-changed", false)
      )




      ###
      If the object had been hidden, toggle it's hide property
      ###
      if old_hide is "yes"


        # Change Property in Server
        hide = new Mywebroom.Models.HideUserItemsDesignByUserIdAndItemsDesignIdAndLocationIdModel({_id: user_id})
        hide.user_id =        user_id
        hide.item_design_id = old_design_id
        hide.location_id =    location_id
        hide.save
          wait: true
        ,
          success: (model, response) ->
            #console.log("TOGGLE DESIGN HIDE SUCCESS\n", model)

            error: (model, response) ->
              console.log("TOGGLE DESIGN HIDE FAIL\n", model)




      ###
      Persist the new design properties to the server
      ###
      model = new Mywebroom.Models.UpdateUserItemsDesignByUserIdAndItemsDesignIdAndLocationIdModel(
        {
          new_items_design_id: new_design_id
          _id                : user_id
        }
      )

      model.location_id    = location_id
      model.item_design_id = old_design_id
      model.user_id        = user_id
      model.save
        wait: true
      ,
        success: (model, response) ->
          #console.log("UPDATE DESIGN ID SUCCESS\n", response)


          error: (model, response) ->
            console.error("UPDATE DESIGN ID FAIL\n", response)
    )

}
