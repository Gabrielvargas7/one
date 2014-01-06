class Mywebroom.Routers.RoomsRouter extends Backbone.Router

  routes:
    'editor'         : 'showEditor'
    'editor/collapse': 'collapseEditor'
    'profile'        : 'showProfile'
    'profile/collapse':'collapseProfile'



  showEditor: ->
    Mywebroom.Helpers.EditorHelper.showStore()

  collapseEditor: ->
    Mywebroom.Helpers.EditorHelper.collapseStore()

  showProfile:->
    Mywebroom.Helpers.ProfileHelper.showProfile()

  collapseProfile:->
    Mywebroom.Helpers.ProfileHelper.collapseProfile()



