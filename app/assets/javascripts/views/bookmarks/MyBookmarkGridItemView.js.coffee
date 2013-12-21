class Mywebroom.Views.MyBookmarkGridItemView extends Marionette.ItemView
  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************
  className:"bookmark_grid_item"
  #*******************
  #**** Templeate
  #*******************
  template:JST['bookmarks/MyBookmarkGridItemView']

  events:
    'click .trash_icon_hover':'confirmDeleteBookmark'
    'click .gridItemPicture.my_bookmarks_grid_item':'triggerBrowseMode'
  initialize:->
    if @model.get('title') is "MYWEBROOM_LAST"
      @template = JST['bookmarks/MyBookmarksMoreSquareTemplate']
  #*******************
    #**** Render
    #*******************
  onRender:->
    #$(@el).html(@template(model:@model))
    $(@el).attr('data-cid',@model.cid)
    $(@el).attr('data-id',@model.id)

  confirmDeleteBookmark:(event)->
    #Confirm to delete the bookmark.
    event.stopPropagation()
    modalHTML = JST['bookmarks/ConfirmDeleteBookmarkModal'](model:@model)
    $(@el).append(modalHTML)
    $('#myModal').modal(backdrop:false)
    that=this
    #NOTE: This .on is jQuery NOT Backbone.on.
    $('.delete_bookmark_button').on('click',{@model, that},
      ->
        that.deleteBookmark()
        #that.trigger('deleteBookmark',that.model)
        that.remove())
    #Destroy the modal instead of hide it, since we have changing data inside it. (model name)
    $("#myModal").on "hidden", ->
        $('#myModal').remove()
  triggerBrowseMode:(event)->
    #console.log "Welcome to browse mode! You are browsing:"
    #console.log @model
    Mywebroom.App.vent.trigger('BrowseMode:open',{@model})
    Mywebroom.App.vent.trigger('BrowseMode:closeBookmarkView')

  deleteBookmark:()->
    bookmarkId= @model.get('id')
    position= @model.get('position')
    userId= Mywebroom.State.get('roomUser').id #@getUserSignedInId()
    deletedBookmark = new Mywebroom.Models.DestroyUserBookmarkByUserIdBookmarkIdAndPosition()
    deletedBookmark.set 'url', deletedBookmark.url(userId,bookmarkId,position)
    #Delete the bookmark from the server.
    deletedBookmark.destroyUserBookmark()
    #destroy the modal
    $('#myModal').remove()
