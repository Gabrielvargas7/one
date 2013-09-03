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

    # items
    this.getItemsCollection()
    this.appendItemsEntry()

    # items designs
    this.hideItemsDesignsTab()


    # themes
    this.getThemesCollection()
    this.appendThemesEntry()

    # bundles
    this.getBundlesCollection()
    this.appendBundlesEntry()

    # bundles set
    this.appendBundlesSetEntry()

    this



  #*******************
  #**** Functions  Initialize
  #*******************

  #--------------------------
  # get the items data
  #--------------------------
  getItemsCollection: ->
    @itemsCollection = new Mywebroom.Collections.IndexItemsCollection()
    this.itemsCollection.fetch async: false

  #--------------------------
  # get the Themes data
  #--------------------------
  getThemesCollection: ->
    @themesCollection = new Mywebroom.Collections.IndexThemesCollection()
    this.themesCollection.fetch async: false
#    console.log(JSON.stringify(this.themesCollection.toJSON()))

  #--------------------------
  # get the Bundles data
  #--------------------------
  getBundlesCollection: ->
    @bundlesCollection = new Mywebroom.Collections.IndexBundlesCollection()
    this.bundlesCollection.fetch async: false
#    console.log(JSON.stringify(this.bundlesCollection.toJSON()))


  #--------------------------
  # append items views
  #--------------------------
  appendItemsEntry: ->
    @loop_number = 0
    @row_number = 1
    @column_number = 3

    @row_line = "<ul id='row_item_"+@row_number+"'></ul>"
    this.$('#tab_items').append(@row_line)

    that = this

    @itemsCollection.each (entry)  ->
      @storeMenuItemsView = new Mywebroom.Views.StoreMenuItemsView(model:entry)
      @.$('#row_item_'+that.row_number).append(@storeMenuItemsView.el)
      @storeMenuItemsView.render()
      that.loop_number++

      u = that.loop_number%that.column_number
      if u == 0
       that.row_number++
       that.row_line = "<ul id='row_item_"+that.row_number+"'></ul>"
       this.$('#tab_items').append(that.row_line)



  #--------------------------
  # append themes views
  #--------------------------
  appendThemesEntry: ->
    @loop_number = 0
    @row_number = 1
    @column_number = 3

    @row_line = "<ul id='row_theme_"+@row_number+"'></ul>"
    this.$('#tab_themes').append(@row_line)

    that = this

    @themesCollection.each (entry)  ->
      @storeMenuThemesView = new Mywebroom.Views.StoreMenuThemesView(model:entry)
      @.$('#row_theme_'+that.row_number).append(@storeMenuThemesView.el)
      @storeMenuThemesView.render()
      that.loop_number++

      u = that.loop_number%that.column_number
      if u == 0
        that.row_number++
        that.row_line = "<ul id='row_theme_"+that.row_number+"'></ul>"
        this.$('#tab_themes').append(that.row_line)



  #--------------------------
  # append Bundle views
  #--------------------------
  appendBundlesEntry: ->
    @loop_number = 0
    @row_number = 1
    @column_number = 3

    @row_line = "<ul id='row_bundle_"+@row_number+"'></ul>"
    this.$('#tab_bundles').append(@row_line)

    that = this

    @bundlesCollection.each (entry)  ->
      @storeMenuBundlesView = new Mywebroom.Views.StoreMenuBundlesView(model:entry)
      @.$('#row_bundle_'+that.row_number).append(@storeMenuBundlesView.el)
      @storeMenuBundlesView.render()
      that.loop_number++

      u = that.loop_number%that.column_number

      if u == 0
        that.row_number++
        that.row_line = "<ul id='row_bundle_"+that.row_number+"'></ul>"
        this.$('#tab_bundles').append(that.row_line)


  #--------------------------
  # append Bundles Set views
  #--------------------------
  appendBundlesSetEntry: ->
    @loop_number = 0
    @row_number = 1
    @column_number = 3

    @row_line = "<ul id='row_bundle_set_"+@row_number+"'></ul>"
    this.$('#tab_bundles_set').append(@row_line)
    that = this

    @bundlesCollection.each (entry)  ->
      @storeMenuBundlesSetView = new Mywebroom.Views.StoreMenuBundlesSetView(model:entry)
      @.$('#row_bundle_set_'+that.row_number).append(@storeMenuBundlesSetView.el)
      @storeMenuBundlesSetView.render()
      that.loop_number++

      u = that.loop_number%that.column_number
      if u == 0
        that.row_number++
        that.row_line = "<ul id='row_bundle_set_"+that.row_number+"'></ul>"
        this.$('#tab_bundles_set').append(that.row_line)

  #--------------------------
  # hide items designs tap
  #--------------------------
  hideItemsDesignsTab: ->
    $tab_item_designs = $('[data-toggle="tab"][href="#tab_items_designs"]')
    $tab_item_designs.hide()

