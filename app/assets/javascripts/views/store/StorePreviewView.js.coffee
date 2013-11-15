class Mywebroom.Views.StorePreviewView  extends Backbone.View

  #*******************
  #**** Tag
  #*******************
  tagName: 'li'


  #*******************
  #**** Template
  #*******************
  template: JST['store/StorePreviewTemplate']


  #*******************
  #**** Events
  #*******************
  events: {
    'click .store_container_ITEM img':        'clickItem'
    'click .store_container_DESIGN img':      'clickDesign'
    'click .store_container_THEME img':       'clickTheme'
    'click .store_container_BUNDLE img':      'clickBundle'
    'click .store_container_ENTIRE_ROOM img': 'clickEntireRoom'
    'mouseenter .store_container':            'hoverOn'
    'mouseleave .store_container':            'hoverOff'
  }




  #*******************
  #**** Initialize
  #*******************
  initialize: ->

    @button_preview = $.cloudinary.image(
      'button_preview.png',
      {id: "button_preview"}
    )

    @type = @model.get("type")









  render: ->


    obj =  @model.clone()

    # We set image_name to the matching preview url (when necessary)
    switch @type
      when "ITEM" then false
        # NO CHANGE
      when "DESIGN"
        obj.set("image_name", obj.get("image_name_selection"))
      when "THEME"
        obj.set("image_name", obj.get("image_name_selection"))
      when "BUNDLE" then false
        # NO CHANGE
      when "ENTIRE_ROOM"
        obj.set("image_name", obj.get("image_name_set"))


    $(@el).append(@template({model: obj.toJSON()}))
    this





  addSocialView: ->

    ###
    CREATE and RENDER SocialBarView
    ###
    @socialView = new Mywebroom.Views.SocialBarView({model: @model})
    @socialView.render()

    $('#store_' + @type + '_container_' + @model.get('id'))
    .append(@socialView.el)

    @socialView.hide()



  #*******************
  #**** Events
  #*******************
  clickItem: (event) ->

    event.preventDefault()
    event.stopPropagation()


    itemId = @model.get('id')


    Mywebroom.Helpers.Editor.clickItem(itemId)




  clickDesign: (e) ->

    #console.log(@model)

    e.preventDefault()
    e.stopPropagation()

    ###
    (1) Center
    (2) Update DOM
    (3) Conditionally Show Save Bar
    (4) Highlight
    ###


    #console.log("click design")




    ###
    DESIGN TYPE
    ###
    design_type = @model.get("item_id")




    ###
    (1) CENTER
    ###
    Mywebroom.Helpers.centerItem(design_type)




    ###
    (2) UPDATE DOM
    ###
    Mywebroom.Helpers.updateRoomDesign(@model)



    ###
    (3) CONDITIONALLY SHOW SAVE BAR
    ###
    Mywebroom.Helpers.showSaveBar()




    ###
    (4) HIGHLIGHT
    ###
    Mywebroom.Helpers.highLight(design_type)




    # Find the design that was clicked and
    # create a reference to it's container element
    $activeDesign = $("[data-design-item-id=" + design_type + "]")




    # Save this object to our state model
    Mywebroom.State.set("$activeDesign", $activeDesign)








  clickTheme: (e) ->

    #console.log(@model)

    e.preventDefault()
    e.stopPropagation()


    ###
    (1) UPDATE THEME IN DOM
    ###
    Mywebroom.Helpers.updateRoomTheme(@model)


    ###
    (2) CONDITIONALLY SHOW SAVE BAR
    ###
    Mywebroom.Helpers.showSaveBar()


  clickBundle: (e) ->

    #console.log(@model)

    #console.log("click Store Bundle View " + @model.get('id'))

    e.preventDefault()
    e.stopPropagation()


    designs = @getBundleDesignsCollection(@model.get('id'))


    #console.log("rug", designs.where({item_id: 34}))


    ###
    UPDATE DOM
    ###
    designs.each( (design) ->
      Mywebroom.Helpers.updateRoomDesign(design)
    )



    ###
    CONDITIONALLY SHOW SAVE BAR
    ###
    Mywebroom.Helpers.showSaveBar()


    ###
    NEVER SHOW REMOVE BUTTON FOR A BUNDLE
    ###
    $('#xroom_store_remove').hide()





  clickEntireRoom: (e) ->

    #console.log(@model)

    #console.log("\n\n\nENTIRE ROOMS clicked\n\n\n")

    e.preventDefault()
    e.stopPropagation()



    ###
    FETCH THEME
    ###
    themes = @getBundleThemeCollection(@model.get('theme_id'))
    theme = themes.first()


    ###
    THEME: UPDATE DOM
    ###
    Mywebroom.Helpers.updateRoomTheme(theme)




    ###
    FETCH DESIGNS
    ###
    designs = @getBundleDesignsCollection(@model.get('id'))


    #console.log("rug", designs.where({item_id: 34}))


    d1 = designs.length
    d2 = Object.keys(Mywebroom.Data.ItemModels).length

    if d1 isnt d1

      if d1 < d2

        alert("There are " + d2 + " items, but this user only has " + d1 + "!")

      else

        alert("This user has " + d1 + " designs, but the room only has " + d2 + " total items!")




    ###
    DESIGNS: UPDATE DOM
    ###
    designs.each( (design) ->

      Mywebroom.Helpers.updateRoomDesign(design)
      
    )




    ###
    CONDITIONALLY SHOW SAVE BAR
    ###
    Mywebroom.Helpers.showSaveBar()



    ###
    NEVER SHOW REMOVE BUTTON FOR A ENTIRE ROOM
    ###
    $('#xroom_store_remove').hide()




  hoverOn: (e) ->

    e.preventDefault()
    e.stopPropagation()


    # CLICK TO PREVIEW
    $('#store_' + @type + '_container_' + @model.get('id'))
    .append(@button_preview)


    # SOCIAL ICONS
    if @type isnt "ITEM"
      if ((Mywebroom.State.get("roomState") == "SELF") and Mywebroom.State.get("signInState") and  Mywebroom.State.get("tutorialStep") == 0)
          @socialView.show()





  hoverOff: (e) ->

    e.preventDefault()
    e.stopPropagation()


    # CLICK TO PREVIEW
    $('#button_preview').remove()


    # SOCIAL ICONS
    if @type isnt "ITEM"
      @socialView.hide()










  #--------------------------
  # Fetch Bundle Designs
  #--------------------------
  getBundleDesignsCollection: (id) ->
    collection = new Mywebroom.Collections.IndexItemsDesignsOfBundleByBundleIdCollection()
    collection.fetch
      async:   false
      url:     collection.url(id)
      success: (response) ->
        #console.log("bundle design collection fetch success", response)
      error: ->
        console.log("bundle design collection fail")

    return collection


  #--------------------------
  # Fetch Bundle Theme
  #--------------------------
  getBundleThemeCollection: (id) ->
    collection = new Mywebroom.Collections.ShowThemeByThemeIdCollection()
    collection.fetch
      async:   false
      url:     collection.url(id)
      success: (response) ->
        #console.log("bundle theme collection fetch success", response)
      error: ->
        console.log("bundle theme collection fail")

    return collection
