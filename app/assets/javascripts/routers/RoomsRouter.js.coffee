class Mywebroom.Routers.RoomsRouter extends Backbone.Router

  routes:
    'editor'         : 'showEditor'
    'editor/collapse': 'collapseEditor'



  showEditor: ->
    Mywebroom.Helpers.showStore()

  collapseEditor: ->
    Mywebroom.Helpers.collapseStore()


