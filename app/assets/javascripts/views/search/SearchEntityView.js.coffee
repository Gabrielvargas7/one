class Mywebroom.Views.SearchEntityView extends Backbone.View

  #*******************
  #**** Template
  #*******************
  template: JST['search/SearchEntityTemplate']


  #*******************
  #**** Events
  #*******************
  events: {
    'click':      'click'
    'mouseenter': 'mouseEnter'
  }




  #*******************
  #**** Render
  #*******************
  render: ->

    $(@el).append(@template({entity: @model}))


    this



  #*******************
  #**** Event Functions
  #*******************
  click: ->

    entityType =  @model.get('entityType')

    switch entityType

      when Mywebroom.Models.BackboneSearchEntityModel.BOOKMARK


        if Mywebroom.State.get("signInState")

          #console.log("is a Bookmark")
          @openBookmarkView()

        else

          seoModel = Mywebroom.Helpers.getSEOLink(@model.get('entityId'), 'BOOKMARK')
          window.open(seoModel.get("seo_url"), '_blank')



      when Mywebroom.Models.BackboneSearchEntityModel.PEOPLE

        #console.log("is a People")
        # the under name is the username
        origin =  window.location.origin
        origin += '/room/' + @model.get('displayUnderName')
        window.location.replace(origin)


      when Mywebroom.Models.BackboneSearchEntityModel.ITEM_DESIGN

        if Mywebroom.State.get("signInState")

          #console.log("is a Item Design")
          @openStoreEditor()

        else

          seoModel = Mywebroom.Helpers.getSEOLink(@model.get('entityId'), 'DESIGN')
          window.open(seoModel.get("seo_url"), '_blank')



    # Clear Search
    Mywebroom.State.get("roomHeaderView").hideCleanSearchBox()






  mouseEnter: ->

    if not @model.has('viewNum')
      console.error('Model without viewNum', @model)

    ###
    SET SEARCH NUM
    ###
    Mywebroom.Data.searchNum = @model.get('viewNum')


    ###
    TURN ON HIGHLIGHTING
    ###
    this.$el.toggleClass('highlight-search', true)


    ###
    TURN OFF HIGHLIGHTING
    ###
    $('.highlight-search')
    .not(this.$el)
    .toggleClass('highlight-search', false)









  #*******************
  #**** Event Helpers
  #*******************
  openBookmarkView: ->

    bookmark = @getBookmark(@model.get('entityId'))


    hasId = bookmark.has("id")
    hasItemId = bookmark.has("item_id")
    hasItemName = bookmark.has("item_name")


    if hasId and hasItemId and hasItemName

      existUserBookmark = @existUserBookmarkByBookmarkIdModel(bookmark.get('id'))

      $('#xroom_store_menu_save_cancel_remove').hide()
      $('#xroom_storepage').hide()
      $('#xroom_profile').hide()
      $('#xroom_bookmarks').show()

      bookmarksView = new Mywebroom.Views.BookmarksView({
        items_name: bookmark.get('item_name')
        item_id: bookmark.get('item_id')
        user: Mywebroom.State.get("roomUser").get("id")
      })

      self = this

      $('#room_bookmark_item_id_container_' + bookmark.get('item_id')).append(bookmarksView.el)

      bookmarksView.render()

      if existUserBookmark is false
        bookmarksView.renderDiscover()


      $('#room_bookmark_item_id_container_' + bookmark.get('item_id')).show()

      $('#xroom_header_search_box').hide()
      $('#xroom_header_search_text').val("")

    else

      message = "Bookmark does not have:\n\n"

      if not hasId
        message += "id\n"

      if not hasItemId
        message += "item_id\n"

      if not hasItemName
        message += "item_name\n"

      alert(message)





  openStoreEditor: ->

    #console.log("david code here")

    item_id = @model.get("entityId")

    usable = new Mywebroom.Models.ShowItemDesignByIdModel({id: item_id})
    usable.fetch({
      async: false
      success: (model, response, options) ->
        #console.log("openStoreEditor success")

      error: (model, response, options) ->
        console.error("openStoreEditor fail", response.responseText)
    })


    # (1) Show Store
    Mywebroom.Helpers.showStore()


    # (2) Switch to the hidden tab
    $('#storeTabs a[href="#tab_hidden"]').tab('show')


    # (3) Use model to populate view
    Mywebroom.State.get("storeMenuView").appendOne(usable)




  #*******************
  #**** Bookmark Helpers
  #*******************
  getBookmark: (id) ->

    bookmark = new Mywebroom.Models.ShowBookmarkByIdModel({id: id})
    bookmark.fetch({
      async: false
      success: (model, response, options) ->
        #console.log("bookmark fetch success")

      error: (model, response, options) ->
        console.error("bookmark fetch fail")
    })

    bookmark







  existUserBookmarkByBookmarkIdModel: (bookmark_id) ->


    userBookmarkCollection = new Mywebroom.Collections.ShowUserBookmarkByUserIdAndBookmarkIdCollection([],
      {
        user_id: Mywebroom.State.get("signInUser").id
        bookmark_id: bookmark_id
      }
    )


    userBookmarkCollection.fetch({
      async: false
      success: (collection, response, options) ->
        return true

      error: (collection, response, options) ->
        return false
    })
