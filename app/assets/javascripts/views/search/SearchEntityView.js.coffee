class Mywebroom.Views.SearchEntityView extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************

  #*******************
  #**** Templeate
  #*******************

  template: JST['search/SearchEntityTemplate']



  #*******************
  #**** Events
  #*******************

  events:{

    'mouseenter  .search_container_entity':'enterEntity'
    'mmouseleave .search_container_entity':'leaveEntity'

  }


  #*******************
  #**** Initialize
  #*******************

  initialize: ->


    #*******************
    #**** Render
    #*******************
  render: ->
    console.log("Adding the SearchEntityView with model:")
#    console.log(@options.entry)
#    $(@el).append(@template(entity:@options.entry))
    console.log("Search Entity")
    console.log(@model)
    $(@el).append(@template(entity:@model))

    this


  enterEntity:->
    console.log("Enter to entity")
    $activeDesign = $("[data-room_item_id=" + itemId + "]")

  leaveEntity:->
    console.log("Leave to entity")



