class Mywebroom.Views.StoreMenuSaveCancelRemoveView extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************


  #*******************
  #**** Templeate
  #*******************
  template: JST['store/StoreMenuSaveCancelRemoveTemplate']

  #*******************
  #**** Events
  #*******************

  events:{
    'click #xroom_store_save':'clickStoreSave'

  }

  #*******************
  #**** Initialize
  #*******************
  initialize: ->

    #*******************
    #**** Render
    #*******************
  render: ->
    console.log("store menu save page view: ")
    $(@el).append(@template())
    this




  #*******************
  #**** Functions  -events
  #*******************
  clickStoreSave: (event) ->
    event.preventDefault()
    console.log("click Store Save")

    this.saveNewTheme()
    this.saveNewItems()


  #*******************
  #**** Functions  -save data
  #*******************

  saveNewTheme: ->
    isThemeNew = $('.current_background').attr("data-room_theme")

    if isThemeNew == "new"
        # set the data-theme to current
        $('.current_background').attr("data-room_theme",'current')

        themeId     = $('.current_background').attr("data-room_theme_id")
        sectionId   = $('.current_background').attr("data-room_section_id")
        userId      = this.options.signInUserDataModel.get('user').id

        updateTheme = new Mywebroom.Models.UpdateUserThemeByUserIdAndSectionIdModel({new_theme_id:themeId, _id: userId})
        updateTheme.section_id=sectionId
        updateTheme.user_id=userId
        updateTheme.save
          success: (model, response) ->
            console.log "SUCCESS:"
            console.log response

          error: (model, response) ->
            console.log "FAIL:"
            console.log response



  saveNewItems: ->
    userItemsDesignsList = this.options.signInUserDataModel.get('user_items_designs')
    length = userItemsDesignsList.length
    i = 0
    while i < length
      userItemsDesigns = userItemsDesignsList[i]
      itemId = userItemsDesigns.item_id
      isItemDesignNew = $('[data-room_item_id='+itemId+']').attr("data-room_item_design")

      i++
      if isItemDesignNew == "new"

        itemDesignIdCurrent = $('[data-room_item_id='+itemId+']').attr("data-room_item_design_id_current")
        itemDesignIdNew = $('[data-room_item_id='+itemId+']').attr("data-room_item_design_id")
        itemLocationId = $('[data-room_item_id='+itemId+']').attr("data-room_location_id")

        $('[data-room_item_id='+itemId+']').attr("data-room_item_design_id_current",itemDesignIdNew)
        $('[data-room_item_id='+itemId+']').attr("data-room_item_design",'current')

        userId      = this.options.signInUserDataModel.get('user').id
        updateItem = new Mywebroom.Models.UpdateUserItemsDesignByUserIdAndItemsDesignIdAndLocationIdModel({new_items_design_id:itemDesignIdNew, _id: userId})
        updateItem.location_id    = itemLocationId
        updateItem.item_design_id = itemDesignIdCurrent
        updateItem.user_id        = userId
        updateItem.save
          success: (model, response) ->
            console.log "SUCCESS:"
            console.log response

          error: (model, response) ->
            console.log "FAIL:"
            console.log response



