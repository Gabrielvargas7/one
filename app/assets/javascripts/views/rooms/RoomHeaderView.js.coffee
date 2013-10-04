class Mywebroom.Views.RoomHeaderView extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************

  #*******************
  #**** Templeate
  #*******************

  template: JST['rooms/RoomHeaderTemplate']



  #*******************
  #**** Events
  #*******************

  events:{
    'click #xroom_header_profile'        :'showProfile'
    'click #xroom_header_forward_profile':'forwardToRoRProfilePage'
    'click #xroom_header_forward_setting':'forwardToRoRSettingPage'
    'click #xroom_header_logout':'logout'
    'click #xroom_header_storepage':'showStorePage'
    'click #xroom_header_myroom':'goToMyRoom'
    'keyup #xroom_header_search_text':'keyPressOnSearch'
    'focusout #xroom_header_search_text': 'focusOutSearchTextBox',

  }


  #*******************
  #**** Initialize
  #*******************

  initialize: ->
    @model = Mywebroom.State.get("roomData")


  #*******************
  #**** Render
  #*******************
  render: ->
    $(@el).append(@template(user_data: Mywebroom.State.get("roomData")))
    @createStorePage()
    @createProfileView()
    @removeRoomHeaderElemments()

    @
    # Create Search Box
    searchView = new Mywebroom.Views.SearchView()
    $("#xroom_header_search_box").append(searchView.el)
    $("#xroom_header_search_box").hide()
    searchView.render()





  #*******************
  #**** Functions header
  #*******************

  #--------------------------
  #  *** function remove header elemenst
  #--------------------------
  removeRoomHeaderElemments: ->
    roomState   = Mywebroom.State.get("roomState")
    signInState = Mywebroom.State.get("signInState")
    
    
    $('#xroom_header_storepage').remove() if roomState isnt "SELF"
      

    if roomState is "PUBLIC"
      $('#xroom_header_profile').remove()
      $('.dropdown').remove()
      @showProfile(null)


    $('#xroom_header_myroom').remove() if signInState isnt true
      


  #*******************
  #**** Functions get Collection data
  #*******************

  #--------------------------
  # get the user room info
  #--------------------------
  getUserSignInDataCollection:(userId) ->
    @userAllRoomDataCollection = new Mywebroom.Collections.ShowRoomByUserIdCollection()
    @userAllRoomDataCollection.fetch
      async: false
      url  : @userAllRoomDataCollection.url userId
      
      




  #*******************
  #**** Functions Profile
  #*******************

  #--------------------------
  #  *** function showProfile
  #--------------------------
  showProfile: (event) ->
    if event  # this is is because this fuction is also called when room is PUBLIC
      event.preventDefault()
    
    @displayProfile()


  createProfileView:->
    @profile = new Backbone.Model
    @profile.set(@model.get('user_profile'))
    @profile.set('user', @model.get('user'))
    @profile.set('user_photos', @model.get('user_photos'))
    @profile.set('user_items_designs', @model.get('user_items_designs'))

    @profileView = new Mywebroom.Views.ProfileHomeView(
      {
        model         : @profile,
        roomHeaderView: @ 
      }
    )
    
    $('#xroom_profile').html(@profileView.el)
    @profileView.render()
    $('#xroom_profile').hide()





    #*******************
  #**** Functions the forward to RoR
  #*******************

  #--------------------------
  #  *** function forwardToRoRProfilePage this function work on RoR, we should change to Backbone
  #--------------------------
  forwardToRoRProfilePage:(event) ->
    event.preventDefault()
   
    origin =  window.location.origin
    origin += "/users_profiles/show_users_profiles_by_user_id/" + @model.get('user').id
    
    window.location.replace(origin)


  #--------------------------
  #  *** function  forwardToRoRSettingPage
  #--------------------------
  forwardToRoRSettingPage:(event) ->
    event.preventDefault()
  
    origin =  window.location.origin
    origin += "/users/" + @model.get('user').id
   
    # Why do we use set location.href instead of calling location.replace() ??
    window.location.href = origin 




  #*******************
  #**** Functions the to logout and forward to RoR home
  #*******************

  #--------------------------
  #  *** function createCookies
  #--------------------------
  createCookie: (name, value, days) ->
    if days
      date = new Date()
      date.setTime date.getTime() + (days * 24 * 60 * 60 * 1000)
      expires = "; expires=" + date.toGMTString()
    else
      expires = ""
      
    document.cookie = name + "=" + value + expires + "; path=/"


  #--------------------------
  #  *** function eraseCookies
  #--------------------------
  eraseCookie: (name) ->
    this.createCookie(name, "", -1)


  #--------------------------
  #  *** function logout
  #--------------------------
  logout:(event) ->
    event.preventDefault()
   
    origin = window.location.origin
   
    this.eraseCookie "remember_token"
    window.location.href = origin



  #*******************
  #**** Functions StorePage
  #*******************

  #--------------------------
  #  *** function
  #--------------------------
  showStorePage: (event) ->
    if event  # this is is because this fuction is also call when is PUBLIC_ROOM
      event.preventDefault()
      event.stopPropagation()
   
    @displayStorePage()




  createStorePage:->
    @storePageView = new Mywebroom.Views.StorePageView({ model: @model, roomHeaderView: @ })
    $('#xroom_storepage').html(@storePageView.el)
    @storePageView.render()
    $('#xroom_storepage').hide()
    $('#xroom_store_menu_save_cancel_remove').hide()



  #--------------------------
  #  *** function display
  #--------------------------
  displayStorePage: ->
    $('#xroom_storepage').show()
    $('#xroom_profile').hide()
    $('#xroom_bookmarks').hide()
    $('#xroom_header_search_box').hide()


  #--------------------------
  #  *** function
  #--------------------------
  displayProfile: ->
    $('#xroom_store_menu_save_cancel_remove').hide()
    $('#xroom_storepage').hide()
    $('#xroom_profile').show()
    $('#xroom_bookmarks').hide()
    $('#xroom_header_search_box').hide()



  displaySearchPage: ->
    $('#xroom_store_menu_save_cancel_remove').hide()
    $('#xroom_storepage').hide()
    $('#xroom_profile').hide()
    $('#xroom_bookmarks').hide()
    $('#xroom_header_search_box').show()





  #--------------------------
  #  *** function
  #--------------------------
  removeHeaderEvents: ->
    $(this.el).off('click', '#xroom_header_storepage')
    $(this.el).off('click', '#xroom_header_profile')
    $('.room_user_item_design_container').off()



  #*******************
  #**** Functions MyRoom
  #*******************

  goToMyRoom: (event) ->
    event.preventDefault()
    event.stopPropagation()

    origin =  window.location.origin
    origin += '/room/' + Mywebroom.State.get("signInUser").get("username")
   
    window.location.replace(origin)


  #*******************
  #**** Functions Search
  #*******************

  keyPressOnSearch:(event)->
    event.preventDefault()
    event.stopPropagation()
    console.log(event.type, event.keyCode)
    if  event.keyCode == 13
      $('#xroom_header_search_box').hide()
      console.log("do something")
    else
      @displaySearchPage()
      console.log("value "+$('#xroom_header_search_text').val())
      value = $('#xroom_header_search_text').val()

      searchUsers = new Mywebroom.Collections.IndexSearchesUsersWithLimitAndOffsetAndKeywordCollection()
      searchUsers.fetch
        async  : false
        url    : searchUsers.url(10,0,value)
        success: ->
          console.log(searchUsers.toJSON())
          console.log("- JSON.stringify "+JSON.stringify(searchUsers))
        error: ->
          console.log("error")

      searchUsersModel = searchUsers.first()
      searchUsersArray = searchUsersModel.get("users")
      console.log(searchUsersArray)

      _.each(searchUsersArray, (user)->

        console.log(user.user_id)
        view = new Mywebroom.Views.SearchEntityView({entry:user})
        this.$('.header_search_wrapper').append(view.render().el)

      )


  focusOutSearchTextBox:(event)->
    event.preventDefault()
    event.stopPropagation()
    console.log("clean textbox values")
    $('#xroom_header_search_text').val("");




