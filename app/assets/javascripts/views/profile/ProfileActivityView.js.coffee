class Mywebroom.Views.ProfileActivityView extends Backbone.View
  #el:"#profileActivityTable"
  tagName:'table'
  className: 'profileHome_activity generalGrid'
  template: JST['profile/ProfileHomeGridTemplate']
  
  initialize: ->
    
  render: ->
    #this template will be the parent one which defines the table
    $(@el).html(@template(activity:@collection))
    #Split collection into rows of three and send them to GridRowView (which goes to GridItemView)
    k=0
    rowArray= []
    console.log("@collection.models.length: "+@collection.models.length)
    while k < @collection.models.length
      i = 0
      while i < 3
        rowArray.push @collection.at k  if k < @collection.models.length
        k+=1
        i++
      rowView = new Mywebroom.Views.ProfileGridRowView(collection: rowArray,originalCollection:@collection)
      $(@el).append rowView.el
      rowView.render()
      rowArray.length = 0
    this
    

    # #this template will be the parent one which defines the table
    # $(@el).html(@template(activity:@collection))
    # #Send first 3 models to row template. this view's template will define the rows
    # slicedCollection = @collection.first 3
    # rowView = new Mywebroom.Views.ProfileGridRowView(collection:slicedCollection)
    # $(@el).append(rowView.el)
    # rowView.render()
    # for each item in @collection
    #   rowView = new Mywebroom.Views.ProfileGridRow(collection:item)
    #   $(@el).append(rowView.el)
    #   rowView.render()

    #Send next 3 model to row template 
    #Should template iterate over collection 
    # or should a separate grid item view be created?
  # showSocialBarView:(event)->
 #      console.log("showSocialBarView function runs")
 #      clickedModel = this.collection.get(event.currentTarget.dataset.id)
 #      #model is undefined here. Get the specific model hovered over
 #      socialBarView = new Mywebroom.Views.SocialBarView(model:clickedModel)
 #      $(@el).append(socialBarView.el)
 #      socialBarView.render() 
 #  closeSocialBarView:->
 #      console.log("closeSocialBarView functio runs")