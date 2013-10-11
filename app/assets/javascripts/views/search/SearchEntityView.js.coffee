class Mywebroom.Views.SearchEntityView extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************
  tagName:'div'
  className:'class_search_entity_view'


  #*******************
  #**** Templeate
  #*******************

  template: JST['search/SearchEntityTemplate']



  #*******************
  #**** Events
  #*******************

  events:{
    'click .search_container_entity'      :'clickEntity'
    'mouseenter  .search_container_entity':'enterEntity'
    'mouseleave .search_container_entity' :'leaveEntity'

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
    console.log("Enter to entity "+@model.get('viewNum'))
    $("[data-id_search_entity_id=search_entity_container_id_"+@model.get('viewNum') + "]").css({backgroundColor : "#bbb"})

  leaveEntity:->
    console.log("Leave to entity "+@model.get('viewNum'))
    $("[data-id_search_entity_id=search_entity_container_id_"+@model.get('viewNum') + "]").css({backgroundColor : "#fff"})

  clickEntity:->
    console.log("click the entity "+@model.get('viewNum'))
    console.log("display Type "+@model.get('entityType'))
    console.log("entityId "+@model.get('entityId'))
    console.log("displayTopName "+@model.get('displayTopName'))
    console.log("displayUnderName "+@model.get('displayUnderName'))
    $("[data-id_search_entity_id=search_entity_container_id_"+@model.get('viewNum') + "]").css({backgroundColor : "#202020"})



