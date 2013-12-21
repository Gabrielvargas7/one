class Mywebroom.Routers.RoomsRouter extends Backbone.Router

  routes:
    'editor'         : 'showEditor'
    'editor/collapse': 'collapseEditor'



  showEditor: ->
    Mywebroom.Helpers.EditorHelper.showStore()

  collapseEditor: ->
    Mywebroom.Helpers.EditorHelper.collapseStore()


