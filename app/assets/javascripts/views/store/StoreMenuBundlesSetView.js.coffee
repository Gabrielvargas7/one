class Mywebroom.Views.StoreMenuBundlesSetView  extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************

  tagName: 'li'
  #*******************
  #**** Templeate
  #*******************
  template: JST['store/StoreMenuBundlesSetTemplate']


  #*******************
  #**** Events
  #*******************
  events:
    'click .store_container_bundle_set':'clickStoreBundleSet'
    'mouseenter .store_container_bundle_set':'hoverStoreBundleSet'
    'mouseleave .store_container_bundle_set':'hoverOffStoreBundleSet'

  #*******************
  #**** Initialize
  #*******************
  initialize: ->



    #*******************
    #**** Render
    #*******************
  render: ->

#    console.log("Store Menu Bundle View "+@model.get('id'))
    $(@el).append(@template(bundle:@model))
    this

  #*******************
  #**** Funtions  -- Collecton
  #*******************

  #--------------------------
  # get items deisgns of the bundle
  #--------------------------
  getBundleItemDesignsCollection:(bundleId) ->
    bundleItemsDesignsCollection = new Mywebroom.Collections.IndexItemsDesignsOfBundleByBundleIdCollection()
    bundleItemsDesignsCollection.fetch
      url:bundleItemsDesignsCollection.url bundleId
      async:false
      success: (response)->
        console.log("@bundleItemsDesignsCollection: ")
        console.log(response)

    return bundleItemsDesignsCollection


  #--------------------------
  # get theme of the bundle
  #--------------------------
  getBundleThemeCollection:(themeId) ->
    bundleThemeCollection = new Mywebroom.Collections.ShowThemeByThemeIdCollection()
    bundleThemeCollection.fetch
      url:bundleThemeCollection.url themeId
      async:false
      success: (response)->
        console.log("bundleTheme: ")
        console.log(response)

    return bundleThemeCollection


  #*******************
  #**** Funtions  -- events
  #*******************

  #--------------------------
  # do something on click
  #--------------------------
  clickStoreBundleSet: (event) ->
    event.preventDefault()
    console.log("click")
    
    
    # Show the view with the Save, Cancel, Remove buttons
    $('#xroom_store_menu_save_cancel_remove').show()
    
    
    # Hide the remove button
    $('#xroom_store_remove').hide()


    # set the new theme
    bundleThemeCollection = this.getBundleThemeCollection(@model.get('theme_id'))
    bundleThemeModel = bundleThemeCollection.first()
    $('.current_background').attr("src",  bundleThemeModel.get('image_name').url);
    $('.current_background').attr("data-room_theme_id",bundleThemeModel.get('id'));
    $('.current_background').attr("data-room_theme",'new');


    # set the new items
    bundleItemsDesignsCollection = this.getBundleItemDesignsCollection(@model.get('id'))
    bundleItemsDesignsCollection.each (entry)  ->
      itemId = entry.get('item_id')
      itemDesignId = entry.get('id')
      imageName = entry.get('image_name').url
      imageNameHover = entry.get('image_name_hover').url

      $('[data-room_item_id='+itemId+']').attr("src", imageName)
      $('[data-room_item_id='+itemId+']').attr("data-room_item_design_id",itemDesignId)
      $('[data-room_item_id='+itemId+']').hover (->  $(this).attr("src",imageNameHover)), -> $(this).attr("src",imageName)
      $('[data-room_item_id='+itemId+']').attr("data-room_item_design",'new')




  #--------------------------
  # change hover image on maouse over
  #--------------------------
  hoverStoreBundleSet: (event) ->
    event.preventDefault()
    console.log("hover "+this.model.get('id'))
    button_preview = $.cloudinary.image 'button_preview.png',{ alt: "button preview", id: "button_preview"}
    $('#store_bundle_set_container_'+this.model.get('id')).append(button_preview)




  #--------------------------
  # change normal image on hover
  #--------------------------
  hoverOffStoreBundleSet: (event) ->
    event.preventDefault()
    console.log("hoverOff"+this.model.get('id'))
    $('#button_preview').remove()







