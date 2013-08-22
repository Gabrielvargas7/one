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

  }
#  **********************
#  *** function showProfile
#  **********************

  initialize: ->

  #*******************
  #**** Render
  #*******************
  render: ->
    console.log("Adding the RoomHeaderView with model:")
    $(@el).append(@template(user_data:@model))
    this


  #*******************
  #**** Functions Profile
  #*******************


  #--------------------------
  #  *** function showProfile
  #--------------------------
  showProfile: (event) ->
    event.preventDefault()
    @profile = new Backbone.Model
    @profile.set(@model.get('user_profile'))
    @profile.set('user',@model.get('user'))
    @profile.set('user_photos',@model.get('user_photos'))
    @showProfileView()


  #--------------------------
  #  *** function showProfileView
  #--------------------------
  showProfileView: ->
    @profileView = new Mywebroom.Views.ProfileHomeView(model:@profile)
    $('#xroom_profile').append(@profileView.el)
    @profileView.render()


  #--------------------------
  #  *** function closeProfileView
  #--------------------------
  closeProfileView: ->
    console.log('CloseProfileView Function running')
    @profileView.remove();
    #Need to listen for #ProfileOpen again
    #Need to enable other room events again.


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
  #**** Functions showStorePage
  #*******************

  #--------------------------
  #  *** function
  #--------------------------
  showStorePage:  ->
    console.log('storePage Function running')
    storePageView = new Mywebroom.Views.StorePageView(model:@model)
    $('#xroom_storepage').append(storePageView.el)
    storePageView.render()
