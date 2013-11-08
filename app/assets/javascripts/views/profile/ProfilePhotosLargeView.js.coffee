class Mywebroom.Views.PhotosLargeView extends Backbone.View
  template: JST['profile/ProfilePhotosLargeTemplate']
  className: 'activity_item_large_wrap'
  events:
    "click #photos_next":"insideHandler"
    "click #photos_prev":"insideHandler"
    "click .social_bar":"setAsProfilePicture"
    "click #profile_close_button_wrap":'closeViewNoProp'
    "click #profile_collapse_arrow":'closeViewNoProp'
  initialize: ->
     _.bindAll this, 'insideHandler', 'outsideHandler'
  render: ->
    $("#profile_drawer").css "width", "1320px" 
    #append Social Bar icons View
    $('body').on('click', this.outsideHandler);
    $(@el).html(@template(model:@model))
    this
    
  insideHandler: (event) ->
    event.stopPropagation()
    console.log "insideHandler called"
  outsideHandler: ->
    console.log "outsideHandler called"
    @closeView()
    return false
  
  setAsProfilePicture:(event)->
    event.stopPropagation()
    alert('you clicked me')

  closeView:->

    $('body').off('click', this.outsideHandler);
    #change profile_draw widths back to original
    $("#profile_drawer").css "width", "760px"
    this.$el.remove()
    console.log "PhotosLargeView closed"
    this
  closeViewNoProp:(event)->
    event.stopPropagation()
    alert('you clicked me')
    @closeView()
    