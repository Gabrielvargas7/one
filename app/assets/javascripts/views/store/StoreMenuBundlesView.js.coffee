class Mywebroom.Views.StoreMenuBundlesView  extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************

  tagName: 'li'
  #*******************
  #**** Templeate
  #*******************
  template: JST['store/StoreMenuBundlesTemplate']


  #*******************
  #**** Events
  #*******************
  events:
    'click .store_container_bundle'     :'clickStoreBundle'
    'mouseenter .store_container_bundle':'hoverStoreBundle'
    'mouseleave .store_container_bundle':'hoverOffStoreBundle'

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
  #**** Funtions  getCollecton
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
    #        console.log("@bundleItemsDesignsCollection:: "+JSON.stringify(response.toJSON()))

    return bundleItemsDesignsCollection




  #*******************
  #**** Funtions - evens
  #*******************

  #--------------------------
  # change all items of the room for bundle when click
  #--------------------------
  clickStoreBundle: (event) ->
    event.preventDefault()
    console.log("click Store Bundle View "+@model.get('id'))
    
    # Show the view with the Save, Cancel, Remove buttons
    $('#xroom_store_menu_save_cancel_remove').show()
    
    
    # SET STATE OF SAVE, CANCEL, REMOVE BUTTONS
    # Show the save button
    $('#xroom_store_save').show()
    
    # Show the cancel button
    $('#xroom_store_cancel').show()
    
    # Hide the remove button
    $('#xroom_store_remove').hide()
    
    
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
  hoverStoreBundle: (event) ->
    event.preventDefault()
    console.log("hover "+this.model.get('id'))
    button_preview = $.cloudinary.image 'button_preview.png',{ alt: "button preview", id: "button_preview"}
    $('#store_bundle_container_'+this.model.get('id')).append(button_preview)




  #--------------------------
  # change normal image on hover
  #--------------------------
  hoverOffStoreBundle: (event) ->
    event.preventDefault()
    console.log("hoverOff"+this.model.get('id'))
    $('#button_preview').remove()







