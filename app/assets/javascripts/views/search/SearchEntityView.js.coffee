class Mywebroom.Views.SearchEntityView extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************
  tagName:'div'
  className:'class_search_entity_view'


  #*******************
  #**** Template
  #*******************

  template: JST['search/SearchEntityTemplate']



  #*******************
  #**** Events
  #*******************

  events:{
    'click .search_container_entity'      :'clickEntity'
    'mouseenter  .search_container_entity':'enterEntity'
    'mouseleave .search_container_entity' :'leaveEntity'

  }


  #*******************
  #**** Initialize
  #*******************

  initialize: ->


    #*******************
    #**** Render
    #*******************
  render: ->
    #console.log("Adding the SearchEntityView with model:")
    #console.log("Search Entity")
    #console.log(@model)
    $(@el).append(@template({entity: @model}))


    this


  enterEntity: ->
    #console.log("Enter to entity "+@model.get('viewNum'))
    $("[data-id_search_entity_id=search_entity_container_id_" + @model.get('viewNum') + "]").css({backgroundColor : "#bbb"})

  leaveEntity: ->
    #console.log("Leave to entity "+@model.get('viewNum'))
    $("[data-id_search_entity_id=search_entity_container_id_" + @model.get('viewNum') + "]").css({backgroundColor : "#fff"})

  clickEntity: ->
    #console.log("click the entity "+@model.get('viewNum'))
    #console.log("display Type "+@model.get('entityType'))
    #console.log("entityId "+@model.get('entityId'))
    #console.log("displayTopName "+@model.get('displayTopName'))
    #console.log("displayUnderName "+@model.get('displayUnderName'))

#    $("[data-id_search_entity_id=search_entity_container_id_"+@model.get('viewNum') + "]").css({backgroundColor : "#202020"})

    entityType =  @model.get('entityType')

    switch entityType
      when Mywebroom.Models.BackboneSearchEntityModel.BOOKMARK
        #console.log("is a Bookmark")
        @openBookmarkView()

      when Mywebroom.Models.BackboneSearchEntityModel.PEOPLE

        #console.log("is a People")
        # the under name is the username
        origin =  window.location.origin
        origin += '/room/' + @model.get('displayUnderName')
        window.location.replace(origin)

      when Mywebroom.Models.BackboneSearchEntityModel.ITEM_DESIGN
        #console.log("is a Item Design")
        @openStoreEditor()



  openBookmarkView: ->
    # find the item designs of the bookmark

    @bookmarkModel = @getShowBookmarkByBookmarkIdModel()
    existUserBookmark = @existUserBookmarkByBookmarkIdModel(@bookmarkModel.get('id'))

    $('#xroom_store_menu_save_cancel_remove').hide()
    $('#xroom_storepage').hide()
    $('#xroom_profile').hide()
    $('#xroom_bookmarks').show()

    bookmarksView = new Mywebroom.Views.BookmarksView({
      items_name: @bookmarkModel.get('item_name')
      item_id: @bookmarkModel.get('item_id')
      user: Mywebroom.State.get("roomUser").get("id")
    })

    self = this
    $('#room_bookmark_item_id_container_' + @bookmarkModel.get('item_id')).append(bookmarksView.el)
    bookmarksView.render()
    if existUserBookmark == false
      bookmarksView.renderDiscover()

    $('#room_bookmark_item_id_container_' + @bookmarkModel.get('item_id')).show()

    $('#xroom_header_search_box').hide()
    $('#xroom_header_search_text').val("")



  getShowBookmarkByBookmarkIdModel: ->
    
    bookmarkCollection = new Mywebroom.Collections.ShowBookmarkByBookmarkIdCollection()
    bookmarkCollection.fetch({
      async  : false
      url    : bookmarkCollection.url(@model.get('entityId'))
      success: ->
        #console.log("print bookmark info")
        #console.log(bookmarkCollection.toJSON())

      error: ->
        #console.log("error")
    })

    bookmarkModel = bookmarkCollection.first()
    bookmarkModel




  existUserBookmarkByBookmarkIdModel: (bookmark_id) ->
    
    signInData = Mywebroom.State.get("signInData")
    console.log("existBookmark function")
    console.log(signInData)
    userBookmarkCollection = new Mywebroom.Collections.ShowUserBookmarkByUserIdAndBookmarkIdCollection()
    userBookmarkCollection.fetch({
      async  : false
      url    : userBookmarkCollection.url(signInData.get('user').id,bookmark_id)
      success: ->
        #console.log("print user bookmark info")
        #console.log(userBookmarkCollection.toJSON())

      error: ->
        #console.log("error")
    })

    userBookmarkModel = userBookmarkCollection.first()
    
    #console.log(userBookmarkModel)
    
    if userBookmarkModel is undefined
      value = false
    else
      value = true
    #console.log("value "+value.toString())
    value




  openStoreEditor: ->
    
    #console.log("david code here")

    item_id = @model.get("entityId")
    
    usable = new Mywebroom.Models.ShowItemDesignByIdModel({id: item_id})
    usable.fetch({
      async: false
      success: (model, response, options) ->
        #console.log("model fetch success")
      error: (model, response, options) ->
        #console.error("model fetch fail", response.responseText)
    })
    

    # (1) Show Store
    Mywebroom.Helpers.showStore()


    # (2) Switch to the hidden tab
    $('#storeTabs a[href="#tab_hidden"]').tab('show')
    
    
    # (3) Use model to populate view
    Mywebroom.State.get("storeMenuView").appendOne(usable)
