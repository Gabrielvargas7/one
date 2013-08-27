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
    @i = 0
    this.$('#tab1_items').append('<tr>')
    @itemsCollection.each(@appendEntry)



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
#    console.log("fetch userRoomCollection: "+JSON.stringify(this.itemsCollection.toJSON()))

  appendEntry: (entry) =>
    @i++;
#    view = new Raffler.Views.EntriesEntry(model:entry)
#    this.$('#entries').append(view.render().el)
#
#    if i==3
#      this.$('#tab1_items').append('</tr><tr>')


    @storeMenuItemsView = new Mywebroom.Views.StoreMenuItemsView(model:entry)
    this.$('#tab1_items').append(@storeMenuItemsView.el)
    @storeMenuItemsView.render()

#    templ = "<tr><td><%=model.get('name')%></td></tr>"
#
#    rows = _.map(data, (item) ->
#      _.template templ, value: item)
#       html = rows.join("")
#
#      $("#mytable").empty().append html