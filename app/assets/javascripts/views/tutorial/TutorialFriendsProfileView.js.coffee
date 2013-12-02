class Mywebroom.Views.TutorialFriendsProfileView extends Backbone.View


  #*******************
  #**** Template
  #*******************
  template: JST['tutorial/TutorialFriendsProfileTemplate']


  #*******************
  #**** Events
  #*******************
  events: {
    'click #tutorial_friends_profile_btn':    'tutorialFriendsProfileBtn'
    'click #tutorial_friends_profile_facebook_btn':     'inviteFriendsFacebook'

  }


  #*******************
  #**** Render
  #*******************
  render: ->

    # THIS VIEW
    $(@el).html(@template())

    this




  #--------------------------
  # close store page
  #--------------------------
  tutorialFriendsProfileBtn: (e) ->

    e.preventDefault()
    e.stopPropagation()

    
    Mywebroom.State.get('profileHomeView').showHomeGrid()
    $('#xroom_profile').hide()


    user_id  = Mywebroom.State.get("signInUser").get("id")
    tutorial_step = 10
    # save the new step on the tutorial
    Mywebroom.Helpers.TutorialHelper.saveTutorialStep(user_id,tutorial_step)


    #console.log("tutorial Friends Profile")
    view = new Mywebroom.Views.TutorialShowMeMyRoomView()
    $("#xroom_tutorial_container").append(view.el)
    view.render()


    #console.log('Kill: ', this)
    this.unbind() # Unbind all local event bindings
    this.remove() # Remove view from DOM
    delete this.$el # Delete the jQuery wrapped object variable
    delete this.el




  inviteFriendsFacebook: (e) ->
    e.preventDefault()
    e.stopPropagation()


    signInState = Mywebroom.State.get("signInState")
    if signInState is true
      requestMessage = "Your friend " + Mywebroom.State.get("signInData").get("user_profile").firstname + " " + Mywebroom.State.get("signInData").get("user_profile").lastname + " would like to invite you to join myWebRoom.com, a visual way to organize your online life. Create a virtual room, add your favorite products, access all your sites, and check out your friend's room!"
    else
      requestMessage = "Your friend would like to invite you to join myWebRoom.com, a visual way to organize your online life. Create a virtual room, add your favorite products, access all your sites, and check out your friend's room!"
    FB.ui
      method: "apprequests"
      message: requestMessage
    , (request) ->
      #console.log 'inviteFriendsFacebook ui call: '
      #console.log request
