class Mywebroom.Views.RoomView extends Backbone.Marionette.ItemView

  #*******************
  #**** Template *****
  #*******************
  template: JST["rooms/RoomTemplate"]



  #*******************
  #**** Initialize ***
  #*******************
  initialize: ->
    # get room user
    @userRoomCollection = this.getRoomLoadingUserCollection()
    @userRoomModel = @userRoomCollection.first()

    # get sign in user if exist
    @mainUserCollection = this.getUserSignInCollection()
    if @mainUserCollection is undefined
       @signInUser = false
       console.log("sign in false")

       @mainUserModel = @userRoomCollection.first()
    else
       @mainUserModel = @mainUserCollection.first()
       @signInUser = true
       console.log("sign in true")




    if @userRoomModel.id is undefined
      this.forwardToRoot()
    else

      this.FLAGS_MAP['FLAG_PROFILE'] = this.setProfileFlags(@signInUser,@mainUserModel,@userRoomModel)
      this.FLAGS_MAP['FLAG_SIGN_IN'] = this.setSignInFlag(@signInUser)


      # get user room data
      @roomUserDataCollection = this.getRoomUserDataCollection(@userRoomModel.get('id'))
      @roomUserDataModel = @roomUserDataCollection.first()

      # get user sign in data
      @mainUserDataCollection = this.getSignInUserDataCollection(@mainUserModel.get('id'))
      @mainUserDataModel = @mainUserDataCollection.first()

      console.log("@roomUserData: ")
      console.log(@roomUserDataModel)

      # this.setRoomTheme  @roomUserDataModel
      this.setRoomItemsDesigns(@roomUserDataModel, this.FLAGS_MAP['FLAG_PROFILE'])
      this.setRoomHeader( @roomUserDataModel, @mainUserDataModel, this.FLAGS_MAP)
      this.setStoreMenuSaveCancelRemove(@mainUserDataModel)
      this.setRoomScrolls(@roomUserDataModel)
      this.setBrowseMode()

      # center the windows  and remove the scroll
      $(window).scrollLeft(2300)
      $('body').css('overflow-x', 'hidden');

      this.setEventTest()
      this.setBrowseModeEvents()


    this

    self = @
    
      else






    #add the images
    storeRemoveButton = $.cloudinary.image 'store_remove_button.png',{ alt: "store remove button", id: "store_remove_button"}
    $('#xroom_store_remove').prepend(storeRemoveButton)
    storeSaveButton = $.cloudinary.image 'store_save_button.png',{ alt: "store save button", id: "store_save_button"}
    $('#xroom_store_save').prepend(storeSaveButton)
    storeCancelButton = $.cloudinary.image 'store_cancel_button.png',{ alt: "store cancel button", id: "store_cancel_button"}
    $('#xroom_store_cancel').prepend(storeCancelButton)
  #--------------------------
  # set browse mode 
  #--------------------------
  setBrowseMode:->
    @browseModeView = new Mywebroom.Views.BrowseModeView()
    $('#xroom_bookmarks_browse_mode').append(@browseModeView.el)
    $('#xroom_bookmarks_browse_mode').hide()
    @browseModeView.render()
  #--------------------------
  # change browse mode. (Pass a new model to it)
  #--------------------------
  changeBrowseMode:(model)->
    $("#xroom_bookmarks_browse_mode").show()
    $(".browse_mode_view").show()
    @browseModeView.activeSiteChange(model)



   
    
  #--------------------------
  # set room on the rooms.html
  #--------------------------
  setRoom: (xroom_item_num) ->    
    $(xroom_item_num).append(@template(user_theme: Mywebroom.State.get("roomTheme")))
    
    
    _.each(Mywebroom.State.get("roomDesigns"), (design)->  
      view = new Mywebroom.Views.RoomUserItemsDesignsView({design: design})
      $(xroom_item_num).append(view.el)
      view.render()
      view.undelegateEvents() if Mywebroom.State.get("roomState") is "PUBLIC"
    )
    
  #-------------------------------
  # set bookmarks on the rooms.html
  #-------------------------------
  setBookmarksRoom: ->
    $("#xroom_bookmarks").hide()
    
    roomUser = Mywebroom.State.get("roomUser")
    designs  = Mywebroom.State.get("roomDesigns")
    
    
    length = designs.length
    i = 0
    
    while i < length
      if designs[i].clickable is "yes"
        bookmarkHomeView = new Mywebroom.Views.BookmarkHomeView(
          {
            user_item_design: designs[i],
            user            : roomUser
          }
        )
        
        $("#xroom_bookmarks").append(bookmarkHomeView.el)
        bookmarkHomeView.render()
        
        $("#room_bookmark_item_id_container_" + designs[i].item_id).hide()
        
      i++
