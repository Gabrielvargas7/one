class Mywebroom.Views.XProfileHomeView extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************
  className: 'user_profile'

  #*******************
  #**** Templeate
  #*******************

  template: JST['profile/XProfileHomeTemplate']
#
#  #*******************
#  #**** Events
#  #*******************
#  events:
#
#  #*******************
#  #**** Initialize
#  #*******************
  initialize: ->
#
#
#  #*******************
#  #**** Render
#  #*******************
  render: ->
    console.log("profile home open")
    $(@el).append(@template)
    this



#*******************
  #**** Funtions
  #*******************


  #*******************
  #**** Funtions  Profile
  #*******************




