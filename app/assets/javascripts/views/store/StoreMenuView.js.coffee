class Mywebroom.Views.StoreMenuView extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************


  #*******************
  #**** Templeate
  #*******************
  template: JST['store/StoreMenuTemplate']

  #*******************
  #**** Events
  #*******************

  events:{


  }

  #*******************
  #**** Initialize
  #*******************
  initialize: ->

  #*******************
  #**** Render
  #*******************
  render: ->
    console.log("storemenu view: ")
    console.log(@model)

    $(@el).append(@template())

    # hide object tab ItemsDesignsTab
#    this.hideItemsDesignsTab()

    # items
    @itemsCollection = this.getItemsCollection()
    this.appendItemsEntry(@itemsCollection)

    # items designs
    @itemsDesignsCollection = this.getItemsDesignsCollection(@itemsCollection.first().get('id'))
    this.appendItemsDesignsEntry(@itemsDesignsCollection)

    # themes
    @themesCollection = this.getThemesCollection()
    this.appendThemesEntry(@themesCollection)

    # bundles
    @bundlesCollection = this.getBundlesCollection()
    this.appendBundlesEntry(@bundlesCollection)

    # bundles set
    this.appendBundlesSetEntry(@bundlesCollection)


    this



  #*******************
  #**** Functions  - get Collection
  #*******************

  #--------------------------
  # get the items data
  #--------------------------
  getItemsCollection: ->
    itemsCollection = new Mywebroom.Collections.IndexItemsCollection()
    itemsCollection.fetch async: false
    return itemsCollection

  #--------------------------
  # get the items designs data
  #--------------------------
  getItemsDesignsCollection: (item_id) ->
    itemsDesignsCollection = new Mywebroom.Collections.IndexItemsDesignsByItemIdCollection()
    itemsDesignsCollection.fetch
      async:false
      url:itemsDesignsCollection.url item_id
      success:(response) ->
        console.log("items designs fetch successful: ")
        console.log(response)
    return itemsDesignsCollection


  #--------------------------
  # get the Themes data
  #--------------------------
  getThemesCollection: ->
    themesCollection = new Mywebroom.Collections.IndexThemesCollection()
    themesCollection.fetch async: false
#    console.log(JSON.stringify(this.themesCollection.toJSON()))
    return themesCollection

  #--------------------------
  # get the Bundles data
  #--------------------------
  getBundlesCollection: ->
    bundlesCollection = new Mywebroom.Collections.IndexBundlesCollection()
    bundlesCollection.fetch async: false
#    console.log(JSON.stringify(this.bundlesCollection.toJSON()))
    return bundlesCollection


  #*******************
  #**** Functions  - append Collection to room store page
  #*******************

  #--------------------------
  # append items views
  #--------------------------
  appendItemsEntry:(itemsCollection) ->
    @loop_number = 0
    @row_number = 1
    @column_number = 3

    @row_line = "<ul id='row_item_"+@row_number+"'></ul>"
    $('#tab_items').append(@row_line)

    that = this

    itemsCollection.each (entry)  ->
      storeMenuItemsView = new Mywebroom.Views.StoreMenuItemsView(model:entry)
      $('#row_item_'+that.row_number).append(storeMenuItemsView.el)
      storeMenuItemsView.render()

      that.loop_number++
      u = that.loop_number%that.column_number

      if u == 0
       that.row_number++
       that.row_line = "<ul id='row_item_"+that.row_number+"'></ul>"
       $('#tab_items').append(that.row_line)


  #--------------------------
  # append items designs views
  #--------------------------

  appendItemsDesignsEntry:(itemsDesignsCollection) ->

    $("#tab_items_designs > ul").remove()
    @loop_number = 0
    @row_number = 1
    @column_number = 3

    @row_line = "<ul id='row_item_designs_"+@row_number+"'></ul>"
    this.$('#tab_items_designs').append(@row_line)

    that = this
    itemsDesignsCollection.each (entry)  ->
      storeMenuItemsDesignsView = new Mywebroom.Views.StoreMenuItemsDesignsView(model:entry)
      $('#row_item_designs_'+that.row_number).append(storeMenuItemsDesignsView.el)
      storeMenuItemsDesignsView.render()
      that.loop_number++

      u = that.loop_number%that.column_number
      if u == 0
        that.row_number++
        that.row_line = "<ul id='row_item_designs_"+that.row_number+"'></ul>"
        $('#tab_items_designs').append(that.row_line)


  #--------------------------
  # append themes views
  #--------------------------
  appendThemesEntry:(themesCollection) ->
    @loop_number = 0
    @row_number = 1
    @column_number = 3

    @row_line = "<ul id='row_theme_"+@row_number+"'></ul>"
    $('#tab_themes').append(@row_line)

    that = this

    themesCollection.each (entry)  ->
      storeMenuThemesView = new Mywebroom.Views.StoreMenuThemesView(model:entry)
      $('#row_theme_'+that.row_number).append(storeMenuThemesView.el)
      storeMenuThemesView.render()

      that.loop_number++
      u = that.loop_number%that.column_number

      if u == 0
        that.row_number++
        that.row_line = "<ul id='row_theme_"+that.row_number+"'></ul>"
        $('#tab_themes').append(that.row_line)



  #--------------------------
  # append Bundle views
  #--------------------------
  appendBundlesEntry:(bundlesCollection) ->
    @loop_number = 0
    @row_number = 1
    @column_number = 3

    @row_line = "<ul id='row_bundle_"+@row_number+"'></ul>"
    $('#tab_bundles').append(@row_line)

    that = this

    bundlesCollection.each (entry)  ->
      storeMenuBundlesView = new Mywebroom.Views.StoreMenuBundlesView(model:entry)
      $('#row_bundle_'+that.row_number).append(storeMenuBundlesView.el)
      storeMenuBundlesView.render()

      that.loop_number++
      u = that.loop_number%that.column_number

      if u == 0
        that.row_number++
        that.row_line = "<ul id='row_bundle_"+that.row_number+"'></ul>"
        $('#tab_bundles').append(that.row_line)


  #--------------------------
  # append Bundles Set views
  #--------------------------
  appendBundlesSetEntry:(bundlesCollection) ->
    @loop_number = 0
    @row_number = 1
    @column_number = 3

    @row_line = "<ul id='row_bundle_set_"+@row_number+"'></ul>"
    $('#tab_bundles_set').append(@row_line)
    that = this

    bundlesCollection.each (entry)  ->
      storeMenuBundlesSetView = new Mywebroom.Views.StoreMenuBundlesSetView(model:entry)
      $('#row_bundle_set_'+that.row_number).append(storeMenuBundlesSetView.el)
      storeMenuBundlesSetView.render()

      that.loop_number++
      u = that.loop_number%that.column_number

      if u == 0
        that.row_number++
        that.row_line = "<ul id='row_bundle_set_"+that.row_number+"'></ul>"
        $('#tab_bundles_set').append(that.row_line)




  #*******************
  #**** Functions  - hide tabs
  #*******************

  #--------------------------
  # hide items designs tap
  #--------------------------
  hideItemsDesignsTab: ->
    $tab_item_designs = $('[data-toggle="tab"][href="#tab_items_designs"]')
    $tab_item_designs.hide()


