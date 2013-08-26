class Mywebroom.Views.StorePageView extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************


  #*******************
  #**** Templeate
  #*******************
  template: JST['store/StoreTemplate']

  #*******************
  #**** Events
  #*******************

  events:{
    'click #store_close_button':'closeStorePageView'

  }

  #*******************
  #**** Initialize
  #*******************
  initialize: ->

  #*******************
  #**** Render
  #*******************
  render: ->
    console.log("storepage view: ")
    console.log(@model)
#    alert("user id: "+@model.get('user').id)
    $(@el).append(@template())
    this



  #*******************
  #**** Functions  Initialize Room
  #*******************
  closeStorePageView: ->
    console.log('add all the event to the header')
    this.options.roomHeaderView.delegateEvents() # add all header events

    console.log('delete storePageView ')
    this.model.destroy() # Unbind reference to the model
    this.unbind()        # Unbind all local event bindings
    this.remove()        # Remove view from DOM
    delete this.$el      # Delete the jQuery wrapped object variable
    delete this.el       # Delete the variable reference to this node




