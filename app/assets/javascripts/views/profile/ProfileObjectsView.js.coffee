class Mywebroom.Views.ProfileObjectsView extends Backbone.View
  className:'profile_objects_view'
  template: JST['profile/ProfileObjectsTemplate']
  initialize: ->
    if(@model.get("FLAG_PROFILE") is "PUBLIC")
     @collection.reset(@collection.first(9), silent:true)
  events:
    'click #profile_ask_for_key_overlay button':'askForKey'

  render: ->
    $(@el).html(@template(collection: @collection,model:@model))
    #append objects table.
    objectsTableView = new Mywebroom.Views.ProfileActivityView2(collection: @collection, model:@model,headerName:"OBJECTS")
    $(@el).append(objectsTableView.render().el)
    this

  askForKey:(event)->
    console.log("ItemsDesigns- Ask for "+@model.get('user_id')+' '+@model.get('firstname')+' key request from ME. (Who am I?)')