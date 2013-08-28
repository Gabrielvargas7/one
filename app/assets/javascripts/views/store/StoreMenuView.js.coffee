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
#    alert("user id: "+@model.get('user').id)

    $(@el).append(@template())
    this.getItemsCollection()
    this.getThemesCollection()
    this.getBundlesCollection()

    @type = 'items'
    @row_number = 0
    @itemsCollection.each(@appendItemsEntry)
    @row_number = 0
    @type = 'themes'
    @themesCollection.each(@appendThemesEntry)
    @row_number = 0
    @type = 'bundles'
    @bundlesCollection.each(@appendBundlesEntry)

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
  # get the items data
  #--------------------------
  getThemesCollection: ->
    @themesCollection = new Mywebroom.Collections.IndexThemesCollection()
    this.themesCollection.fetch async: false
#    console.log(JSON.stringify(this.themesCollection.toJSON()))

  getBundlesCollection: ->
    @bundlesCollection = new Mywebroom.Collections.IndexBundlesCollection()
    this.bundlesCollection.fetch async: false
    console.log(JSON.stringify(this.bundlesCollection.toJSON()))



  appendItemsEntry: (entry) ->
    # Initialize values
    unless @row_number
      @item_number = 0
      @row_number = 1
      @column_number = 3


    @row_line = "<ul id='row_number_"+@row_number+"'></ul>"
    this.$('#tab_items').append(@row_line)

    @storeMenuItemsView = new Mywebroom.Views.StoreMenuItemsView(model:entry)
    this.$('#row_number_'+@row_number).append(@storeMenuItemsView.el)
    @storeMenuItemsView.render()
    @item_number++;

    u = @item_number%@column_number
    if u == 0
      @row_number++;
      @row_line = "<ul id='row_number_"+@row_number+"'></ul>"
      this.$('#tap_items').append(@row_line)


  appendThemesEntry: (entry) ->
    # Initialize values
    unless @row_number
      @item_number = 0
      @row_number = 1
      @column_number = 3


    @row_line = "<ul id='row_number_"+@row_number+"'></ul>"
    this.$('#tab_themes').append(@row_line)

    @storeMenuItemsView = new Mywebroom.Views.StoreMenuItemsView(model:entry)
    this.$('#row_number_'+@row_number).append(@storeMenuItemsView.el)
    @storeMenuItemsView.render()
    @item_number++;

    u = @item_number%@column_number
    if u == 0
      @row_number++;
      @row_line = "<ul id='row_number_"+@row_number+"'></ul>"
      this.$('#tap_themes').append(@row_line)

  appendBundlesEntry: (entry) ->
    # Initialize values
    unless @row_number
      @item_number = 0
      @row_number = 1
      @column_number = 3


    @row_line = "<ul id='row_number_"+@row_number+"'></ul>"
    this.$('#tab_bundles').append(@row_line)

    @storeMenuItemsView = new Mywebroom.Views.StoreMenuItemsView(model:entry)
    this.$('#row_number_'+@row_number).append(@storeMenuItemsView.el)
    @storeMenuItemsView.render()
    @item_number++;

    u = @item_number%@column_number
    if u == 0
      @row_number++;
      @row_line = "<ul id='row_number_"+@row_number+"'></ul>"
      this.$('#tap_bundles').append(@row_line)

