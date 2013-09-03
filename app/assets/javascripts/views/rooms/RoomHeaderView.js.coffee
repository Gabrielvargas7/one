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
    'click #xroom_header_profile':'showProfile'
    'click #xroom_header_forward_profile':'forwardToRoRProfilePage'
    'click #xroom_header_forward_setting':'forwardToRoRSettingPage'
    'click #xroom_header_logout':'logout'
    'click #xroom_header_storepage':'showStorePage'
    'click #xroom_header_myroom':'goToMyRoom'


  }


  #*******************
  #**** Initialize
  #*******************

  initialize: ->

  #*******************
  #**** Render
  #*******************
  render: ->
    console.log("Adding the RoomHeaderView with model:")
    $(@el).append(@template(user_data:this.options.signInUserDataModel))
    this.removeRoomHeaderElemments(this.options.FLAGS_MAP)
    this



  #*******************
  #**** Functions header
  #*******************

  #--------------------------
  #  *** function remove header elemenst
  #--------------------------
  removeRoomHeaderElemments:(flagsMap)->
    if flagsMap['FLAG_PROFILE'] != Mywebroom.Views.RoomView.MY_ROOM
      $('#xroom_header_storepage').remove()

    if flagsMap['FLAG_PROFILE'] == Mywebroom.Views.RoomView.PUBLIC_ROOM
      $('#xroom_header_profile').remove()
      $('.dropdown').remove()
      this.showProfile(null)

    if !flagsMap['FLAG_SIGN_IN']
      $('#xroom_header_myroom').remove()



  #*******************
  #**** Functions get Collection data
  #*******************

  #--------------------------
  # get the user room info
  #--------------------------
  getUserSignInDataCollection:(userId) ->
    @userAllRoomDataCollection = new Mywebroom.Collections.ShowRoomByUserIdCollection()
    @userAllRoomDataCollection.fetch
      url:@userAllRoomDataCollection.url userId
      async:false
      success: (response)->
        console.log("@userAllRoomDataCollection: ")
        console.log(response)
#        console.log("@userAllRoomDataCollection: "+JSON.stringify(response.toJSON()))




  #*******************
  #**** Functions Profile
  #*******************

  #--------------------------
  #  *** function showProfile
  #--------------------------
  showProfile: (event) ->
    if event  # this is is because this fuction is also call when is PUBLIC_ROOM
      event.preventDefault()
    @profile = new Backbone.Model
    @profile.set(@model.get('user_profile'))
    @profile.set('user',@model.get('user'))
    @profile.set('user_photos',@model.get('user_photos'))
    @profile.set('user_items_designs',@model.get('user_items_designs'))
    @showProfileView()


  #--------------------------
  #  *** function showProfileView
  #--------------------------
  showProfileView:() ->
    @profileView = new Mywebroom.Views.ProfileHomeView({model:@profile,FLAG_PROFILE:this.options.FLAGS_MAP['FLAG_PROFILE'],roomHeaderView:this })
    $('#xroom_profile').append(@profileView.el)
    @profileView.render()
    @removeHeaderEvents()




  #*******************
  #**** Functions the forward to RoR
  #*******************

  #--------------------------
  #  *** function forwardToRoRProfilePage this function work on RoR, we should change to Backbone
  #--------------------------
  forwardToRoRProfilePage:(event) ->
    event.preventDefault()
    console.log('forwardToRoRProfilePage Function running')
    origin = window.location.origin
    origin = origin+"/users_profiles/show_users_profiles_by_user_id/"+@model.get('user').id
    console.log("forward to: "+origin)
    window.location.replace(origin)


  #--------------------------
  #  *** function  forwardToRoRSettingPage
  #--------------------------
  forwardToRoRSettingPage:(event) ->
    event.preventDefault()
    console.log('forwardToRoRSettingPage Function running')
    origin = window.location.origin
    origin = origin+"/users/"+@model.get('user').id
    console.log("forward to: "+origin)
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
    console.log('logout Function running')
    origin = window.location.origin
    console.log("forward to: "+origin)
    this.eraseCookie "remember_token"
    window.location.href = origin



  #*******************
  #**** Functions StorePage
  #*******************

  #--------------------------
  #  *** function
  #--------------------------
  showStorePage: (event) ->
    event.preventDefault()
    event.stopPropagation()
    console.log('storePage Function running')
    @storePageView = new Mywebroom.Views.StorePageView({model:@model,roomHeaderView:this})
    $('#xroom_storepage').append(@storePageView.el)
    @storePageView.render()
    @removeHeaderEvents()

  #--------------------------
  #  *** function events
  #--------------------------
  removeHeaderEvents: ->
    $(this.el).off('click', '#xroom_header_storepage')
    $(this.el).off('click', '#xroom_header_profile')



  #*******************
  #**** Functions MyRoom
  #*******************

  goToMyRoom: (event) ->
    event.preventDefault()
    event.stopPropagation()
    console.log('go to my room')
    origin = window.location.origin
    myOrigin = origin+'/room/'+this.options.signInUserDataModel.get('user').username
    console.log(myOrigin)
    console.log("forward to: "+myOrigin)
    window.location.replace(myOrigin)






